import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import '../../domain/repositories/tenant_repository.dart';

class PostTenantRequestScreen extends StatefulWidget {
  const PostTenantRequestScreen({super.key});

  @override
  State<PostTenantRequestScreen> createState() => _PostTenantRequestScreenState();
}

class _PostTenantRequestScreenState extends State<PostTenantRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minBudgetController = TextEditingController(text: '4000');
  final _maxBudgetController = TextEditingController(text: '8000');
  final _locationsController = TextEditingController(text: 'حي الجامعة، المشاية');
  final _lifestyleController = TextEditingController();
  int _bedrooms = 2;
  bool _needsFurnished = true;
  final int _flexibilityScore = 6;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    _locationsController.dispose();
    _lifestyleController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      final repo = context.read<TenantRepository>();
      final result = await repo.createTenantRequest(
        minBudget: num.parse(_minBudgetController.text),
        maxBudget: num.parse(_maxBudgetController.text),
        preferredLocations: _locationsController.text.trim(),
        requiredBedrooms: _bedrooms,
        needsFurnished: _needsFurnished,
        flexibilityScore: _flexibilityScore,
        lifestyleRequirements: _lifestyleController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم نشر طلب السكن بنجاح! سيتم إخطارك فور وصول عروض الملاك.'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.failure?.message ?? 'فشل نشر الطلب'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نشر طلب سكن مخصص'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMd),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'انشر مواصفات شقتك المطلوبة وسيقوم الملاك المعتمدون بتقديم عروض إيجار مباشرة لك',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLg),

                // Budget Range
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'أقل ميزانية (ج.م)',
                        controller: _minBudgetController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(LucideIcons.coins, size: 18),
                        validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'أعلى ميزانية (ج.م)',
                        controller: _maxBudgetController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(LucideIcons.coins, size: 18),
                        validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMd),

                // Preferred Locations
                AppTextField(
                  label: 'المناطق والأحياء المفضلة (المنصورة)',
                  hint: 'مثال: حي الجامعة، المشاية، توريل، شارع الترعة...',
                  controller: _locationsController,
                  prefixIcon: const Icon(LucideIcons.map_pin, size: 18),
                  validator: (val) => val == null || val.isEmpty ? 'يرجى تحديد المناطق' : null,
                ),
                const SizedBox(height: AppConstants.paddingMd),

                // Bedrooms
                Text(
                  'عدد غرف النوم المطلوبة',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [1, 2, 3, 4].map((count) {
                    final isSelected = _bedrooms == count;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text('$count غرف'),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) => setState(() => _bedrooms = count),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.paddingMd),

                // Needs Furnished
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('أحتاج شقة مفروشة بالكامل', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  value: _needsFurnished,
                  activeThumbColor: AppColors.accent,
                  onChanged: (val) => setState(() => _needsFurnished = val),
                ),
                const SizedBox(height: AppConstants.paddingMd),

                // Lifestyle Requirements
                AppTextField(
                  label: 'متطلبات نمط المعيشة والملاحظات',
                  hint: 'مثال: هادئة للدراسة، قريبة من المواصلات العامة، دور منخفض أو مصعد متاح...',
                  controller: _lifestyleController,
                  maxLines: 3,
                ),
                const SizedBox(height: AppConstants.paddingXl),

                AppButton(
                  text: 'نشر الطلب وبدء استقبال العروض',
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
