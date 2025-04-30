import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/filter.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<FilterGroup> allFilters;
  final Set<String> selectedFilters;
  final Function(Set<String>) onApply;
  final VoidCallback onClear;

  const FilterBottomSheet({
    required this.allFilters,
    required this.selectedFilters,
    required this.onApply,
    required this.onClear,
    Key? key,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _tempSelectedFilters;

  @override
  void initState() {
    super.initState();
    _tempSelectedFilters = Set<String>.from(widget.selectedFilters);
  }

  void _onCategoryTapped(String id) {
    setState(() {
      if (_tempSelectedFilters.contains(id)) {
        _tempSelectedFilters.remove(id);
      } else {
        _tempSelectedFilters.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Filters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onClear,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.allFilters.length,
                  itemBuilder: (context, sectionIndex) {
                    final group = widget.allFilters[sectionIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            group.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(group.categories.length,
                              (itemIndex) {
                            final category = group.categories[itemIndex];
                            final isSelected =
                                _tempSelectedFilters.contains(category.id);
                            return ChoiceChip(
                              key: Key(
                                  'filter_chip_${sectionIndex}_${itemIndex}'),
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (_) => _onCategoryTapped(category.id),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  key: Key('apply_filter_button'),
                  onPressed: () {
                    widget.onApply(_tempSelectedFilters);
                  },
                  child: const Text('Apply Filters'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
