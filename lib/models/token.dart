import 'dart:convert';

class Token {
  final String symbol;
  final double quantity;
  final double price; // preço unitário em USD
  final String iconPath;

  const Token({
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.iconPath,
  });

  double get usdValue => quantity * price;

  Token copyWith({
    String? symbol,
    double? quantity,
    double? price,
    String? iconPath,
  }) {
    return Token(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  Map<String, dynamic> toMap() => {
    'symbol': symbol,
    'quantity': quantity,
    'price': price,
    'iconPath': iconPath,
  };

  factory Token.fromMap(Map<String, dynamic> map) => Token(
    symbol: map['symbol'] as String,
    quantity: (map['quantity'] as num).toDouble(),
    price: (map['price'] as num).toDouble(),
    iconPath: map['iconPath'] as String,
  );

  String toJson() => jsonEncode(toMap());
  factory Token.fromJson(String source) =>
      Token.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
