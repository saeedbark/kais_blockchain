# Generated by Django 5.1.4 on 2025-03-05 01:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_alter_transaction_amount_and_more'),
    ]

    operations = [
        migrations.RemoveConstraint(
            model_name='transaction',
            name='unique_transaction_hash',
        ),
        migrations.AlterField(
            model_name='transaction',
            name='amount',
            field=models.DecimalField(decimal_places=10, max_digits=20),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='block_number',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='recipient',
            field=models.CharField(max_length=42),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='sender',
            field=models.CharField(max_length=42),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='tx_hash',
            field=models.CharField(max_length=66, unique=True),
        ),
    ]
