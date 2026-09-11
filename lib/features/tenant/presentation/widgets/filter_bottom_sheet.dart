import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final num? initialMinPrice;
  final num? initialMaxPrice;
  final int? initialBedrooms;
  final bool? initialIsFurnished;
  final String? initialDistrict;
  final Function({
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialBedrooms,
    this.initialIsFurnished,
    this.initialDistrict,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(2000, 25000);
  int? _selectedBedrooms;
  bool? _isFurnished;
  String? _selectedDistrict;

  final List<String> _districts = [
    'الكل',
    'حي الجامعة',
    'المشاية السفلية',
    'المشاية العلوية',
    'توريل الجديدة',
    'شارع جيهان',
    'حي الأشجار',
    'مصر والسودان',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialMinPrice != null || widget.initialMaxPrice != null) {
      _priceRange = RangeValues(
        widget.initialMinPrice?.toDouble() ?? 2000,
        widget.initialMaxPrice?.toDouble() ?? 25000,
      );
    }
    _selectedBedrooms = widget.initialBedrooms;
    _isFurnished = widget.initialIsFurnished;
    _selectedDistrict = widget.initialDistrict ?? 'الكل';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تصفية نتائج البحث',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMd),

            // Budget Slider
            Text(
              'نطاق الميزانية الشهرية: ${_priceRange.start.round()} - ${_priceRange.end.round()} ج.م',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            RangeSlider(
              values: _priceRange,
              min: 1000,
              max: 40000,
              divisions: 39,
              activeColor: AppColors.accent,
              inactiveColor: AppColors.border,
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: AppConstants.paddingMd),

            // Bedrooms
            const Text(
              'عدد غرف النوم',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3, 4].map((count) {
                final isSelected = _selectedBedrooms == count;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$count غرف'),
                      selected: isSelected,
                      selectedColor: AppColors.accent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedBedrooms = selected ? count : null;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.paddingMd),

            // District
            const Text(
              'المنطقة / الحي (المنصورة)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _districts.map((district) {
                final isSelected = _selectedDistrict == district;
                return ChoiceChip(
                  label: Text(district),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDistrict = selected ? district : 'الكل';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.paddingMd),

            // Furnished Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('مفروشة بالكامل', style: TextStyle(fontSize: 14)),
              value: _isFurnished ?? false,
              activeThumbColor: AppColors.accent,
              onChanged: (val) {
                setState(() {
                  _isFurnished = val;
                });
              },
            ),
            const SizedBox(height: AppConstants.paddingLg),

            AppButton(
              text: 'تطبيق الفلاتر',
              onPressed: () {
                widget.onApply(
                  minPrice: _priceRange.start.round(),
                  maxPrice: _priceRange.end.round(),
                  bedrooms: _selectedBedrooms,
                  isFurnished: _isFurnished,
                  district: _selectedDistrict == 'الكل' ? null : _selectedDistrict,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
