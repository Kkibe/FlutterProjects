class Account {
  final String name;
  final String issuer;
  final String secret;

  Account({
    required this.name,
    required this.issuer,
    required this.secret,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'issuer': issuer,
        'secret': secret,
      };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        name: json['name'],
        issuer: json['issuer'],
        secret: json['secret'],
      );
}
