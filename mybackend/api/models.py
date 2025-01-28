from django.db import models
from django.contrib.auth.models import User



class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    eth_address = models.CharField(max_length=42, unique=True)
    balance = models.DecimalField(max_digits=20, decimal_places=10, default=0)

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
    tx_hash = models.CharField(max_length=66, unique=True)  # Transaction hash
    block_number = models.IntegerField()
    timestamp = models.DateTimeField()

    def __str__(self):
        return f"{self.tx_hash} ({self.amount} ETH)"
