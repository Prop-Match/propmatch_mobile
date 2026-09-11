import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import '../cubit/tenant_browse_cubit.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class TenantBrowseScreen extends StatefulWidget {
  const TenantBrowseScreen({super.key});

  @override
  State<TenantBrowseScreen> createState() => _TenantBrowseScreenState();
}

class _TenantBrowseScreenState extends State<TenantBrowseScreen> {
  final _searchController = TextEditingController();
  String _activeChip = 'الكل';

  final List<String> _quickChips = [
    'الكل',
    'مفروش',
    'حي الجامعة',
    'المشاية',
    'توريل',
    '2 غرف',
    '3 غرف',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TenantBrowseCubit>().loadProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChipSelected(String chip) {
    setState(() => _activeChip = chip);
    bool? isFurnished;
    int? bedrooms;
    String? district;

    if (chip == 'مفروش') isFurnished = true;
    if (chip == 'حي الجامعة') district = 'حي الجامعة';
    if (chip == 'المشاية') district = 'المشاية';
    if (chip == 'توريل') district = 'توريل';
    if (chip == '2 غرف') bedrooms = 2;
    if (chip == '3 غرف') bedrooms = 3;

    context.read<TenantBrowseCubit>().loadProperties(
          query: _searchController.text.trim(),
          isFurnished: isFurnished,
          bedrooms: bedrooms,
          district: district,
        );
  }

  void _openFilters(TenantBrowseLoaded? loadedState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        initialMinPrice: loadedState?.minPrice,
        initialMaxPrice: loadedState?.maxPrice,
        initialBedrooms: loadedState?.bedrooms,
        initialIsFurnished: loadedState?.isFurnished,
        initialDistrict: loadedState?.district,
        onApply: ({minPrice, maxPrice, bedrooms, isFurnished, district}) {
          context.read<TenantBrowseCubit>().loadProperties(
                query: _searchController.text.trim(),
                minPrice: minPrice,
                maxPrice: maxPrice,
                bedrooms: bedrooms,
                isFurnished: isFurnished,
                district: district,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اكتشف العقارات'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {
              context.push(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMd,
              vertical: AppConstants.paddingSm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'ابحث باللغة الطبيعية أو المنطقة...',
                    controller: _searchController,
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    onChanged: (val) {
                      if (val.length >= 3 || val.isEmpty) {
                        context.read<TenantBrowseCubit>().loadProperties(query: val.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<TenantBrowseCubit, TenantBrowseState>(
                  builder: (context, state) {
                    final loaded = state is TenantBrowseLoaded ? state : null;
                    return InkWell(
                      onTap: () => _openFilters(loaded),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                        child: const Icon(
                          LucideIcons.sliders_horizontal,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Quick Filter Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
              itemCount: _quickChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final chip = _quickChips[index];
                final isSelected = _activeChip == chip;
                return ChoiceChip(
                  label: Text(chip),
                  selected: isSelected,
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  onSelected: (_) => _onChipSelected(chip),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Content List
          Expanded(
            child: BlocBuilder<TenantBrowseCubit, TenantBrowseState>(
              builder: (context, state) {
                if (state is TenantBrowseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TenantBrowseError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.circle_alert, size: 48, color: AppColors.error),
                        const SizedBox(height: 8),
                        Text(state.message),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TenantBrowseCubit>().loadProperties();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TenantBrowseLoaded) {
                  if (state.properties.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.search, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'لم نجد عقارات مطابقة لبحثك',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'جرب تغيير الفلاتر أو انشر طلب سكن مخصص',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push(AppRoutes.tenantPostRequest);
                            },
                            icon: const Icon(LucideIcons.circle_plus, size: 18),
                            label: const Text('نشر طلب سكن مخصص'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TenantBrowseCubit>().loadProperties(
                            query: state.currentQuery,
                            minPrice: state.minPrice,
                            maxPrice: state.maxPrice,
                            bedrooms: state.bedrooms,
                            isFurnished: state.isFurnished,
                            district: state.district,
                          );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppConstants.paddingMd),
                      itemCount: state.properties.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.paddingMd),
                      itemBuilder: (context, index) {
                        final property = state.properties[index];
                        return PropertyCard(
                          property: property,
                          onTap: () {
                            context.push(AppRoutes.tenantPropertyDetail(property.id), extra: property);
                          },
                          onFavoriteTap: () {
                            context.read<TenantBrowseCubit>().toggleFavorite(property.id);
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
