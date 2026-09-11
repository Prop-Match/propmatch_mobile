import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/features/tenant/presentation/widgets/property_card.dart';
import '../cubit/landlord_dashboard_cubit.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';

class LandlordDashboardScreen extends StatefulWidget {
  const LandlordDashboardScreen({super.key});

  @override
  State<LandlordDashboardScreen> createState() => _LandlordDashboardScreenState();
}

class _LandlordDashboardScreenState extends State<LandlordDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LandlordDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المالك'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.landlordAddProperty);
          if (context.mounted) {
            context.read<LandlordDashboardCubit>().loadDashboard();
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text('إضافة وحدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<LandlordDashboardCubit, LandlordDashboardState>(
        builder: (context, state) {
          if (state is LandlordDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LandlordDashboardError) {
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
                      context.read<LandlordDashboardCubit>().loadDashboard();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is LandlordDashboardLoaded) {
            final stats = state.data.stats;
            final properties = state.data.properties;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LandlordDashboardCubit>().loadDashboard();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quota & Quick Action Banner
                    _buildQuotaBanner(stats),
                    const SizedBox(height: AppConstants.paddingLg),

                    // Stats Grid
                    Text(
                      'ملخص الأداء والنشاط',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: LucideIcons.building,
                            label: 'الوحدات المعلنة',
                            value: '${stats.activeListings} / ${stats.maxActiveListingsAllowed}',
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: LucideIcons.eye,
                            label: 'إجمالي المشاهدات',
                            value: '${stats.totalViews}',
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: LucideIcons.mail,
                            label: 'العروض المستلمة',
                            value: '${stats.receivedOffers}',
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: LucideIcons.sparkles,
                            label: 'المطابقات الذكية',
                            value: '${stats.smartMatchesCount}',
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingXl),

                    // Active Listings Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'وحداتي المعلنة (${properties.length})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (properties.isNotEmpty)
                          TextButton(
                            onPressed: () => context.push(AppRoutes.landlordLeads),
                            child: const Text(
                              'بحث عن مستأجرين',
                              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (properties.isEmpty)
                      _buildEmptyPortfolioView()
                    else
                      ...properties.map((prop) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PropertyCard(
                              property: prop,
                              onTap: () {
                                context.push(AppRoutes.tenantPropertyDetail(prop.id), extra: prop);
                              },
                            ),
                          )),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuotaBanner(LandlordStatsEntity stats) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.crown, color: AppColors.warning, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'رصيد الباقة النشطة',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push(AppRoutes.paymentsPlans),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ترقية الباقة',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'متبقي لديك: ${stats.freeOffersLeft} عروض مباشرة • ${stats.optimizerUsesLeft} استخدامات ذكاء اصطناعي',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPortfolioView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            const Icon(LucideIcons.house, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'لا توجد وحدات معلنة حالياً',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Text(
              'أضف أول وحدة سكنية لعرضها للمستأجرين واستخدام الذكاء الاصطناعي',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'إضافة وحدة الآن',
              icon: const Icon(LucideIcons.circle_plus, size: 18, color: Colors.white),
              onPressed: () => context.push(AppRoutes.landlordAddProperty),
            ),
          ],
        ),
      ),
    );
  }
}
