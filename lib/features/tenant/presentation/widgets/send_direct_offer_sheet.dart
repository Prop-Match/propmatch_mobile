import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import '../../domain/entities/property_entity.dart';

class SendDirectOfferSheet extends StatefulWidget {
  final PropertyEntity property;
  final Function(num proposedPrice, String message) onSubmit;

  const SendDirectOfferSheet({
    super.key,
    required this.property,
    required this.onSubmit,
  });

  @override
  State<SendDirectOfferSheet> createState() => _SendDirectOfferSheetState();
}

class _SendDirectOfferSheetState extends State<SendDirectOfferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.property.rentAmount.toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final price = num.tryParse(_priceController.text) ?? widget.property.rentAmount;
      setState(() => _isSubmitting = true);
      await widget.onSubmit(price, _messageController.text.trim());
      if (mounted) {
        Navigator.pop(context);
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
                    'تقديم عرض إيجار مباشر',
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
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.building, size: 18, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.property.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Text(
                      Formatters.formatCurrency(widget.property.rentAmount),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMd),
              AppTextField(
                label: 'السعر الشهري المقترح (ج.م)',
                controller: _priceController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(LucideIcons.coins, size: 20),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'يرجى إدخال السعر المقترح';
                  if ((num.tryParse(val) ?? 0) <= 0) return 'السعر يجب أن يكون أكبر من صفر';
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMd),
              AppTextField(
                label: 'رسالة للمالك (اختياري)',
                hint: 'مثال: مهتم بالمعاينة نهاية الأسبوع، مدة الإيجار سنة قابلة للتجديد...',
                controller: _messageController,
                maxLines: 3,
              ),
              const SizedBox(height: AppConstants.paddingLg),
              AppButton(
                text: 'إرسال العرض للمالك',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
