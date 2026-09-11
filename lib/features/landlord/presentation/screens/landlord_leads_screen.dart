import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/match_score_badge.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/tenant_request_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import '../../domain/repositories/landlord_repository.dart';
import '../widgets/send_owner_offer_sheet.dart';

class LandlordLeadsScreen extends StatefulWidget {
  const LandlordLeadsScreen({super.key});

  @override
  State<LandlordLeadsScreen> createState() => _LandlordLeadsScreenState();
}

class _LandlordLeadsScreenState extends State<LandlordLeadsScreen> {
  bool _isLoading = true;
  List<TenantRequestEntity> _requests = [];
  List<PropertyEntity> _myProperties = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final repo = context.read<LandlordRepository>();
    final requestsResult = await repo.getTenantRequestsForMatching();
    final propsResult = await repo.getMyProperties();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (requestsResult.isSuccess && requestsResult.data != null) {
          _requests = requestsResult.data!;
        }
        if (propsResult.isSuccess && propsResult.data != null) {
          _myProperties = propsResult.data!;
        }
      });
    }
  }

  void _openSendOffer(TenantRequestEntity request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SendOwnerOfferSheet(
        request: request,
        myProperties: _myProperties,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوق الطلبات المباشرة (Leads)'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.users, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text(
                          'لا توجد طلبات مستأجرين جديدة حالياً',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'سيتم إشعارك فور قيام أي مستأجر بنشر طلب يطابق مواصفات وحداتك',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    itemCount: _requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppConstants.paddingMd),
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      return _buildLeadCard(req);
                    },
                  ),
                ),
    );
  }

  Widget _buildLeadCard(TenantRequestEntity req) {
    final hasHighMatch = (req.matchScore ?? 85) >= 75;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: hasHighMatch ? AppColors.success.withValues(alpha: 0.5) : AppColors.border,
          width: hasHighMatch ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                      radius: 16,
                      child: const Icon(LucideIcons.user, color: AppColors.accent, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      req.tenantName ?? 'مستأجر مؤهل',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                MatchScoreBadge(score: req.matchScore ?? 85),
              ],
            ),
            const SizedBox(height: 12),

            // Specs & Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الميزانية: ${Formatters.formatCurrency(req.minBudget)} - ${Formatters.formatCurrency(req.maxBudget)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent, fontSize: 13),
                ),
                Text(
                  '${req.requiredBedrooms} غرف • ${req.needsFurnished ? "مفروش" : "غير مفروش"}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Preferred Locations
            Row(
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    req.preferredLocations,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),

            if (req.lifestyleRequirements.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'المتطلبات: ${req.lifestyleRequirements}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),

            AppButton(
              text: 'تقديم عرض سعر ووحدة',
              icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
              onPressed: () => _openSendOffer(req),
            ),
          ],
        ),
      ),
    );
  }
}
