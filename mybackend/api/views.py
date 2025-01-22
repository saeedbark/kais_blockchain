from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status
from .models import Account, Transaction
from .serializers import AccountSerializer, TransactionSerializer
from .web3_client import get_all_accounts_with_balances, transfer_amount
from web3 import Web3


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

            # Ensure the amount is positive and non-zero
            if amount <= 0:
                return Response({"error": "Amount must be greater than 0"}, status=400)

            # Transfer amount using Web3
            tx_hash = transfer_amount(sender, recipient, amount)

            # Save the transaction to the database
            transaction = Transaction.objects.create(
                sender=sender,
                recipient=recipient,
                amount=amount,
                tx_hash=Web3.to_hex(tx_hash)
            )

            # Serialize and return the transaction
            serializer = TransactionSerializer(transaction)
            return Response({"transaction": serializer.data}, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=500)
