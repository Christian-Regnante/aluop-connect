import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilterChipList extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> filters;

  const FilterChipList({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.tabInactiveBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected && filter == 'All Missions') ...[
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
