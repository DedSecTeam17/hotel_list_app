import 'package:flutter/material.dart';

class FilterChipGroup extends StatelessWidget {
  final List<String> selected;
  final Function(String) onToggle;

  FilterChipGroup({required this.selected, required this.onToggle, Key? key})
      : super(key: key);

  // QUICK FILTERS
  final List<String> allFilters = [
    "Beach",
    "Lap pool",
    "Free nanny access",
    "Kids pool",
    "Free access for 2 kids"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: allFilters.map((filter) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(filter),
              selected: selected.contains(filter),
              onSelected: (_) => onToggle(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
