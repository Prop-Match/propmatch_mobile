import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/repositories/commercial_repository.dart';
import 'package:propmatch_mobile/features/subscriptions/presentation/cubit/commercial_cubit.dart';
import 'package:propmatch_mobile/features/subscriptions/presentation/screens/payment_webview_screen.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommercialCubit(repository: sl<CommercialRepository>())..fetchCatalogAndQuota(),
      child: const _PackagesView(),
    );
  }
}

class _PackagesView extends StatefulWidget {
  const _PackagesView();

  @override
  State<_PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<_PackagesView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCheckout(BuildContext context, CommercialProductEntity product) {
    context.read<CommercialCubit>().checkout(paymentType: product.paymentType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الباقات والاشتراكات'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'الاشتراكات الشهرية'),
            Tab(text: 'باقات الإضافات والرصيد'),
          ],
        ),
      ),
      body: BlocConsumer<CommercialCubit, CommercialState>(
        listener: (context, state) {
          if (state is CommercialLoaded) {
            if (state.checkoutError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.checkoutError!),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state.checkoutResult != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentWebViewScreen(
                    checkoutUrl: state.checkoutResult!.checkoutUrl,
                  ),
                ),
              ).then((completed) {
                if (completed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إتمام عملية الدفع وتحديث الرصيد بنجاح!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.read<CommercialCubit>().fetchCatalogAndQuota();
                }
              });
            }
          }
        },
        builder: (context, state) {
          if (state is CommercialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CommercialError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.circle_alert, size: 48, color: AppColors.error),
                    const SizedBox(height: AppConstants.paddingMd),
                    const Text('تعذر تحميل باقات الاشتراك'),
                    const SizedBox(height: AppConstants.paddingMd),
                    ElevatedButton(
                      onPressed: () => context.read<CommercialCubit>().fetchCatalogAndQuota(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CommercialLoaded) {
            final subscriptions = state.catalog.products
                .where((p) => p.kind == 'SUBSCRIPTION')
                .toList();
            final addOns = state.catalog.products
                .where((p) => p.kind != 'SUBSCRIPTION')
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(context, subscriptions, state.isCheckingOut),
                _buildProductList(context, addOns, state.isCheckingOut),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    List<CommercialProductEntity> products,
    bool isCheckingOut,
  ) {
    if (products.isEmpty) {
      return const Center(
        child: Text('لا توجد باقات متاحة حالياً'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.paddingMd),
      itemBuilder: (context, index) {
        final product = products[index];
        final isPopular = product.paymentType.contains('PREMIUM') ||
            product.paymentType.contains('OFFERS_10');

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            side: BorderSide(
              color: isPopular ? AppColors.primary : AppColors.border,
              width: isPopular ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.titleArabic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: const Text(
                          'الأكثر طلباً',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.descriptionArabic,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMd),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${product.priceEgp}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ج.م ${product.billing == 'MONTHLY' ? '/ شهرياً' : product.billing == 'YEARLY' ? '/ سنوياً' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMd),
                AppButton(
                  text: 'اشترك الآن',
                  isLoading: isCheckingOut,
                  variant: isPopular ? AppButtonVariant.primary : AppButtonVariant.outline,
                  onPressed: isCheckingOut ? null : () => _onCheckout(context, product),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
