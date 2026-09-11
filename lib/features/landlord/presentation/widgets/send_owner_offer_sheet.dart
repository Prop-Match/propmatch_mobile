import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/tenant_request_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/landlord/domain/repositories/landlord_repository.dart';

class SendOwnerOfferSheet extends StatefulWidget {
  final TenantRequestEntity request;
  final List<PropertyEntity> myProperties;

  const SendOwnerOfferSheet({
    super.key,
    required this.request,
    required this.myProperties,
  });

  @override
  State<SendOwnerOfferSheet> createState() => _SendOwnerOfferSheetState();
}

class _SendOwnerOfferSheetState extends State<SendOwnerOfferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _pitchController = TextEditingController();
  String? _selectedPropertyId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.request.maxBudget.toString();
    if (widget.myProperties.isNotEmpty) {
      _selectedPropertyId = widget.myProperties.first.id;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _pitchController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPropertyId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار الوحدة المراد تقديم العرض بها')),
        );
        return;
      }

      setState(() => _isSubmitting = true);
      final repo = context.read<LandlordRepository>();
      final result = await repo.sendOwnerOffer(
        tenantRequestId: widget.request.id,
        propertyId: _selectedPropertyId!,
        pitchMessage: _pitchController.text.trim(),
        proposedPrice: num.parse(_priceController.text),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال عرضك بنجاح إلى المستأجر'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.failure?.message ?? 'فشل إرسال العرض'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.paddingLg,
        right: AppConstants.paddingLg,
        top: AppConstants.paddingLg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.paddingLg,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تقديم عرض مخصص للمستأجر',
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

              // Request Summary
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Text(
                  'طلب المستأجر: ${widget.request.requiredBedrooms} غرف • ${widget.request.preferredLocations} • الميزانية حتى ${widget.request.maxBudget} ج.م',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMd),

              // Property Selector
              const Text(
                'اختر الوحدة من عقاراتك:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              if (widget.myProperties.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Text(
                    'ليس لديك وحدات معلنة حالياً. يرجى إضافة عقار أولاً لتقديم عرض.',
                    style: TextStyle(fontSize: 12, color: AppColors.warning),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedPropertyId,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: widget.myProperties.map((prop) {
                    return DropdownMenuItem<String>(
                      value: prop.id,
                      child: Text(
                        '${prop.title} (${prop.district})',
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedPropertyId = val),
                ),
              const SizedBox(height: AppConstants.paddingMd),

              // Proposed Rent
              AppTextField(
                label: 'السعر المقترح شهرياً (ج.م)',
                controller: _priceController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(LucideIcons.coins, size: 18),
                validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال السعر' : null,
              ),
              const SizedBox(height: AppConstants.paddingMd),

              // Pitch Message
              AppTextField(
                label: 'رسالة العرض والمميزات الإضافية',
                hint: 'مثال: شقتي مجهزة بالكامل ومطلة على الشارع الرئيسي، مستعد لتوقيع العقد فوراً...',
                controller: _pitchController,
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة رسالة توضيحية' : null,
              ),
              const SizedBox(height: AppConstants.paddingLg),

              AppButton(
                text: 'إرسال العرض للمستأجر',
                isLoading: _isSubmitting,
                onPressed: widget.myProperties.isEmpty ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
