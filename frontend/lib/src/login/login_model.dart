class User {
  final String username;
  final String token;
  final String ethAddress;
  final double balance;

  User({
    required this.username,
    required this.token,
    required this.ethAddress,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      token: json['token'],
      ethAddress: json['eth_address'],
      balance: json['balance']?.toDouble() ?? 0.0,
    );
  }
}
