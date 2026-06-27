import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _minPrice;
  late double _maxPrice;
  late double _minRating;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    _minPrice = provider.minPrice;
    _maxPrice = provider.maxPrice;
    _minRating = provider.minRating;
    _sortBy = provider.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _minPrice = 0;
                    _maxPrice = 20000;
                    _minRating = 0;
                    _sortBy = 'Popularity';
                  });
                },
                child: Text('Reset', style: TextStyle(color: colorScheme.primary)),
              )
            ],
          ),
          const SizedBox(height: 24),
          
          // Sort By Section
          Text('Sort By', style: _headingStyle(colorScheme)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Popularity', 'Price: Low to High', 'Price: High to Low', 'Top Rated'
            ].map((sortOption) {
              final isSelected = _sortBy == sortOption;
              return ChoiceChip(
                label: Text(sortOption),
                selected: isSelected,
                selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _sortBy = sortOption);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Price Range Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price Range', style: _headingStyle(colorScheme)),
              Text(
                'Rs. ${_minPrice.toInt()} - Rs. ${_maxPrice.toInt()}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 20000,
            divisions: 40,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Minimum Rating Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minimum Rating', style: _headingStyle(colorScheme)),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _minRating > 0 ? '${_minRating.toStringAsFixed(1)} & up' : 'Any',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 5,
            activeColor: Colors.orange,
            inactiveColor: Colors.orange.withValues(alpha: 0.2),
            onChanged: (value) {
              setState(() {
                _minRating = value;
              });
            },
          ),
          const SizedBox(height: 32),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false).setFilters(
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  minRating: _minRating,
                  sortBy: _sortBy,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  TextStyle _headingStyle(ColorScheme colorScheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    );
  }
}
