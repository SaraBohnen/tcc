// lib/components/period_filter_dropdown.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Enum para os períodos de filtro
enum PeriodFilter { last7Days, last1Month, last3Months, last1Year }

/// Extensão que fornece o rótulo legível para cada filtro
extension PeriodFilterExtension on PeriodFilter {
  String get label {
    switch (this) {
      case PeriodFilter.last7Days:
        return '7 dias';
      case PeriodFilter.last1Month:
        return '1 mês';
      case PeriodFilter.last3Months:
        return '3 meses';
      case PeriodFilter.last1Year:
        return '1 ano';
    }
  }
}

/// Componente dropdown para seleção de período
class PeriodFilterDropdown extends StatelessWidget {
  final PeriodFilter selectedFilter;
  final ValueChanged<PeriodFilter?> onChanged;
  final String label;

  const PeriodFilterDropdown({
    Key? key,
    required this.selectedFilter,
    required this.onChanged,
    this.label = 'Período:',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        DropdownButton<PeriodFilter>(
          value: selectedFilter,
          items:
              PeriodFilter.values.map((pf) {
                return DropdownMenuItem(value: pf, child: Text(pf.label));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
