// lib/models/performance_point.dart
// Modelo puro para ponto da série (sem dependências de UI)

class PerformancePoint {
  final DateTime date;
  final double value;

  const PerformancePoint(this.date, this.value);

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'value': value,
  };

  factory PerformancePoint.fromJson(Map<String, dynamic> json) =>
      PerformancePoint(
        DateTime.parse(json['date'] as String),
        (json['value'] as num).toDouble(),
      );
}
