import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import 'package:propmatch_mobile/core/utils/deep_link_helper.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import '../../domain/entities/tenant_request_entity.dart';
import '../../domain/entities/owner_offer_entity.dart';
import '../../domain/repositories/tenant_repository.dart';

class MyTenantRequestsScreen extends StatefulWidget {
  const MyTenantRequestsScreen({super.key});

  @override
  State<MyTenantRequestsScreen> createState() => _MyTenantRequestsScreenState();
}

class _MyTenantRequestsScreenState extends State<MyTenantRequestsScreen> {
  bool _isLoading = true;
  List<TenantRequestEntity> _requests = [];
  final Map<String, List<OwnerOfferEntity>> _offersMap = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final repo = context.read<TenantRepository>();
    final result = await repo.getMyTenantRequests();
    if (result.isSuccess && result.data != null) {
      _requests = result.data!;
      // Load incoming offers for each request
      for (var req in _requests) {
        final offersResult = await repo.getIncomingOffers(req.id);
        if (offersResult.isSuccess && offersResult.data != null) {
          _offersMap[req.id] = offersResult.data!;
        }
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _acceptOffer(String offerId) async {
    final repo = context.read<TenantRepository>();
    final result = await repo.acceptOwnerOffer(offerId);
    if (result.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم قبول العرض بنجاح! تم كشف بيانات التواصل وإنشاء المحادثة.'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadRequests();
    }
  }

  Future<void> _rejectOffer(String offerId) async {
    final repo = context.read<TenantRepository>();
    final result = await repo.rejectOwnerOffer(offerId);
    if (result.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم رفض العرض'),
          backgroundColor: AppColors.textSecondary,
        ),
      );
      _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي السكنية والعروض'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () async {
              await context.push(AppRoutes.tenantPostRequest);
              _loadRequests();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? _buildEmptyView()
              : RefreshIndicator(
                  onRefresh: _loadRequests,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    itemCount: _requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppConstants.paddingMd),
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      final offers = _offersMap[req.id] ?? [];
                      return _buildRequestCard(req, offers);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.clipboard_list, size: 54, color: AppColors.textMuted),
            const SizedBox(height: AppConstants.paddingMd),
            const Text(
              'لم تقم بنشر أي طلب سكن بعد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'انشر طلب سكن بمواصفاتك وسيقوم الملاك المعتمدون بتقديم عروض تناسبك مباشرة',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            AppButton(
              text: 'نشر أول طلب سكن',
              icon: const Icon(LucideIcons.circle_plus, size: 18, color: Colors.white),
              onPressed: () async {
                await context.push(AppRoutes.tenantPostRequest);
                _loadRequests();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(TenantRequestEntity req, List<OwnerOfferEntity> offers) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Budget Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'طلب سكن: ${req.requiredBedrooms} غرف • ${req.needsFurnished ? "مفروش" : "غير مفروش"}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${Formatters.formatCurrency(req.minBudget)} - ${Formatters.formatCurrency(req.maxBudget)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => DeepLinkHelper.shareTenantRequest(req),
                      child: const Icon(LucideIcons.share_2, size: 16, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Locations
            Row(
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    req.preferredLocations,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
            if (req.lifestyleRequirements.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                req.lifestyleRequirements,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Offers Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عروض الملاك المستلمة (${offers.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (offers.isNotEmpty)
                  const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 16),
              ],
            ),
            const SizedBox(height: 8),

            if (offers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'بانتظار عروض الملاك... ستصلك إشعارات فور تقديم أي عرض',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              )
            else
              ...offers.map((offer) => _buildOfferItem(offer)),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferItem(OwnerOfferEntity offer) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                offer.ownerName ?? 'مالك عقار معتمد',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                Formatters.formatCurrency(offer.proposedPrice),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            offer.pitchMessage,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          if (offer.status == OwnerOfferStatus.sent || offer.status == OwnerOfferStatus.viewed)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptOffer(offer.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(36),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('قبول وكشف الاتصال', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectOffer(offer.id),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(36),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('رفض', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            )
          else if (offer.status == OwnerOfferStatus.accepted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'تم قبول العرض • يمكنك التواصل الآن من خلال المحادثات',
                style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
