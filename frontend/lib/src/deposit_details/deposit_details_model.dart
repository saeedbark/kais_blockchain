class TransactionModel {
  final String txHash;
  final String sender;
  final String recipient;
  final double amount;
  final int blockNumber;
  final DateTime timestamp;
  final bool isTampered;

  TransactionModel({
    required this.txHash,
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.blockNumber,
    required this.timestamp,
    required this.isTampered,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      txHash: json['tx_hash'],
      sender: json['sender'],
      recipient: json['recipient'],
      amount: double.tryParse(json['amount']) ?? 0.0,
      blockNumber: json['block_number'],
      timestamp: DateTime.parse(json['timestamp']),
      isTampered: json['is_tampered'] ?? false,
    );
  }
}
