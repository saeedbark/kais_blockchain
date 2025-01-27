// lib/models/transaction_model.dart
class TransactionModel {
  final String txHash;
  final String sender;
  final String recipient;
  final double amount;
  final int blockNumber;
  final DateTime timestamp;

  TransactionModel({
    required this.txHash,
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.blockNumber,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      txHash: json['tx_hash'],
      sender: json['sender'],
      recipient: json['recipient'],
      amount: double.tryParse(json['amount']) ?? 0.0,
      blockNumber: json['block_number'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
