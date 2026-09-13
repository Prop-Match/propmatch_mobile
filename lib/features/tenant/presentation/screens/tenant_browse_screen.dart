import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import 'package:propmatch_mobile/features/auth/presentation/cubit/auth_cubit.dart';
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

  Widget _buildWelcomeHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final name = user?.fullName.split(' ').first ?? 'ضيفنا';
        final isVerified = user?.isIdentityVerified ?? false;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('أهلاً، $name 👋',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(LucideIcons.map_pin, color: Colors.white70, size: 12),
                        const SizedBox(width: 4),
                        const Text('المنصورة • ابحث بذكاء باللغة العربية',
                            style: TextStyle(color: Colors.white70, fontSize: 11)),
                        if (isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.shield_check, size: 10, color: AppColors.success),
                                SizedBox(width: 2),
                                Text('موثّق', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (!isVerified)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: InkWell(
                          onTap: () => context.push(AppRoutes.ekyc),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                            child: const Text('وثّق هويتك لزيادة فرص المطابقة →',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(icon: LucideIcons.bot, label: 'المساعد الذكي', sub: 'قانوني + دعم', color: AppColors.primary, onTap: () => context.push(AppRoutes.legalAssistant)),
      _QuickAction(icon: LucideIcons.file_plus, label: 'نشر طلب', sub: 'طلب سكن مخصص', color: AppColors.trustBlue, onTap: () => context.push(AppRoutes.tenantPostRequest)),
      _QuickAction(icon: LucideIcons.bell, label: 'الإشعارات', sub: 'تنبيهات سريعة', color: AppColors.success, onTap: () => context.push(AppRoutes.notifications)),
      _QuickAction(icon: LucideIcons.shield_check, label: 'توثيق الهوية', sub: 'eKYC سريع', color: AppColors.warning, onTap: () => context.push(AppRoutes.ekyc)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('خدمات سريعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: actions.length,
            itemBuilder: (_, i) => _quickCard(actions[i]),
          ),
        ],
      ),
    );
  }

  Widget _quickCard(_QuickAction a) {
    return InkWell(
      onTap: a.onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: a.color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(a.icon, color: a.color, size: 18)),
            const SizedBox(height: 6),
            Text(a.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center),
            Text(a.sub, style: const TextStyle(color: AppColors.textMuted, fontSize: 9), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
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
            icon: const Icon(LucideIcons.bot),
            tooltip: 'المساعد الذكي الموحّد',
            onPressed: () {
              context.push(AppRoutes.legalAssistant);
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.bell),
            tooltip: 'مركز الإشعارات',
            onPressed: () {
              context.push(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Welcome hero + verification banner
          _buildWelcomeHeader(),
          // 2. Quick actions grid - makes every feature 1 tap away
          _buildQuickActions(),
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

class _QuickAction {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;
  _QuickAction({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});
}

