// lib/models/metrics/token_performance.dart
// Modelo puro para itens de desempenho de tokens (para as tabelas Top/Worst)

class TokenPerformance {
  final String name;
  final double price;
  final double sevenDayChange; // em %

  const TokenPerformance({
    required this.name,
    required this.price,
    required this.sevenDayChange,
  });

  TokenPerformance copyWith({
    String? name,
    double? price,
    double? sevenDayChange,
  }) {
    return TokenPerformance(
      name: name ?? this.name,
      price: price ?? this.price,
      sevenDayChange: sevenDayChange ?? this.sevenDayChange,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'sevenDayChange': sevenDayChange,
  };

  factory TokenPerformance.fromJson(Map<String, dynamic> json) =>
      TokenPerformance(
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        sevenDayChange: (json['sevenDayChange'] as num).toDouble(),
      );
}
