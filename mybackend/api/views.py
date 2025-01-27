from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status
from .models import Account, Transaction
from .serializers import AccountSerializer, TransactionSerializer
from .web3_client import get_all_accounts_with_balances, transfer_amount,get_transactions_for_account,web3
from django.utils import timezone
import datetime


class AccountsView(APIView):
    def get(self, request):
        try:
            # Fetch accounts with balances from Ganache
            accounts_with_balances = get_all_accounts_with_balances()

            # Save or update accounts in the database
            for account in accounts_with_balances:
                account_obj, created = Account.objects.update_or_create(
                    address=account['address'],
                    defaults={
                        'balance': account['balance'],
                        'usage_percentage': account['usage_percentage']
                    }
                )

            # Serialize the accounts and return them
            accounts = Account.objects.all()
            serializer = AccountSerializer(accounts, many=True)
            return Response({"accounts_with_balances": serializer.data}, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=500)


class TransferView(APIView):
    def post(self, request):
        try:
            sender = request.data.get('sender')
            recipient = request.data.get('recipient')
            amount = float(request.data.get('amount'))  # Convert to float for decimals

            # Validate input
            if not sender or not recipient or amount <= 0:
                return Response({"error": "Invalid input parameters"}, status=400)

            # Validate Ethereum addresses
            if not web3.is_address(sender):
                return Response({"error": "Invalid sender address"}, status=400)
            if not web3.is_address(recipient):
                return Response({"error": "Invalid recipient address"}, status=400)

            # Transfer amount using Web3
            tx_hash = transfer_amount(sender, recipient, amount)
            
            print('tx_hasg'+tx_hash)

            # Fetch transaction details from the blockchain using the web3 instance
            tx_details = web3.eth.get_transaction(tx_hash)
            tx_receipt = web3.eth.get_transaction_receipt(tx_hash)
            block = web3.eth.get_block(tx_receipt.blockNumber)
            timestamp = datetime.datetime.fromtimestamp(block.timestamp, tz=datetime.timezone.utc)


            # Create and save the transaction in the database
            transaction = Transaction.objects.create(
                sender=sender,
                recipient=recipient,
                amount=amount,
                tx_hash=tx_hash,
                block_number=tx_receipt.blockNumber,
                timestamp=timestamp
            )

            # Serialize and return the transaction
            serializer = TransactionSerializer(transaction)
            return Response({"transaction": serializer.data}, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=500)


class TransactionListView(APIView):
    def get(self, request, address):
        try:
            # Fetch transactions for the given address
            transactions = get_transactions_for_account(address)

            # Save transactions to the database if they don't exist
            for tx in transactions:
                if not Transaction.objects.filter(tx_hash=tx['hash']).exists():
                    # Convert timestamp to datetime
                    tx_timestamp = datetime.datetime.fromtimestamp(tx['timestamp'], tz=datetime.timezone.utc)
                    Transaction.objects.create(
                        sender=tx['from'],
                        recipient=tx['to'],
                        amount=float(tx['value']),
                        tx_hash=tx['hash'],
                        block_number=tx['block_number'],
                        timestamp=tx_timestamp
                    )

            # Retrieve transactions from the database
            transactions_db = Transaction.objects.filter(sender=address) | Transaction.objects.filter(recipient=address)
            transactions_db = transactions_db.order_by('-timestamp')
            serializer = TransactionSerializer(transactions_db, many=True)
            return Response({"transactions": serializer.data}, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=500)