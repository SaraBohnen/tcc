// lib/models/metrics/asset_slice.dart
import 'package:flutter/material.dart';

/// Representa uma fatia de ativo (para gráfico de pizza).
/// Pode ser usado tanto para tokens quanto para redes.
/// Exemplo: {"name": "Bitcoin", "value": 4500.0, "color": "#FFA500"}
class AssetSlice {
  final String name;
  final double value;
  final Color color;

  const AssetSlice({
    required this.name,
    required this.value,
    required this.color,
  });

  AssetSlice copyWith({
    String? name,
    double? value,
    Color? color,
  }) {
    return AssetSlice(
      name: name ?? this.name,
      value: value ?? this.value,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
  };

  factory AssetSlice.fromJson(Map<String, dynamic> json) {
    final colorHex = json['color'] as String;
    // Suporta formato "#AARRGGBB" ou "#RRGGBB"
    int value = int.parse(colorHex.replaceFirst('#', ''), radix: 16);
    if (colorHex.length <= 7) {
      // não contém alpha → assume FF
      value = 0xFF000000 | value;
    }
    return AssetSlice(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      color: Color(value),
    );
  }
}
