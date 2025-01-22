from django.db import models

class Account(models.Model):
    address = models.CharField(max_length=42, unique=True)  # Ethereum address
    balance = models.DecimalField(max_digits=20, decimal_places=10)  # ETH balance
    usage_percentage = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return self.address

class Transaction(models.Model):
    sender = models.CharField(max_length=42)
    recipient = models.CharField(max_length=42)
    amount = models.DecimalField(max_digits=20, decimal_places=10)
    tx_hash = models.CharField(max_length=66)  # Transaction hash

    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.tx_hash} ({self.amount} ETH)"
