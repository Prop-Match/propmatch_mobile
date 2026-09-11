import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import '../../domain/repositories/landlord_repository.dart';

class AddPropertyWizardScreen extends StatefulWidget {
  const AddPropertyWizardScreen({super.key});

  @override
  State<AddPropertyWizardScreen> createState() => _AddPropertyWizardScreenState();
}

class _AddPropertyWizardScreenState extends State<AddPropertyWizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  final _titleController = TextEditingController(text: 'شقة فاخرة للإيجار بالمنصورة');
  final _districtController = TextEditingController(text: 'حي الجامعة');
  final _addressController = TextEditingController(text: 'شارع جيهان، المنصورة');
  final _rentController = TextEditingController(text: '8500');
  final _areaController = TextEditingController(text: '135');
  final _descriptionController = TextEditingController();
  int _bedrooms = 3;
  int _bathrooms = 2;
  bool _isFurnished = true;
  bool _hasElevator = true;
  bool _hasParking = false;

  bool _isOptimizingAi = false;
  bool _isPublishing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateAiDescription() async {
    setState(() => _isOptimizingAi = true);
    final repo = context.read<LandlordRepository>();
    final result = await repo.optimizeDescription(
      title: _titleController.text.trim(),
      district: _districtController.text.trim(),
      areaM2: num.tryParse(_areaController.text) ?? 100,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      isFurnished: _isFurnished,
      amenities: [
        if (_hasElevator) 'مصعد',
        if (_hasParking) 'موقف سيارات',
        if (_isFurnished) 'مفروش بالكامل',
      ],
    );

    if (mounted) {
      setState(() => _isOptimizingAi = false);
      if (result.isSuccess && result.data != null) {
        _descriptionController.text = result.data!;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم توليد الوصف التسويقي بنجاح بواسطة PropMatch AI'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _publishProperty() async {
    setState(() => _isPublishing = true);
    final repo = context.read<LandlordRepository>();
    final result = await repo.createProperty({
      'title': _titleController.text.trim(),
      'district': _districtController.text.trim(),
      'manualAddress': _addressController.text.trim(),
      'rentAmount': num.parse(_rentController.text),
      'areaM2': num.parse(_areaController.text),
      'bedrooms': _bedrooms,
      'bathrooms': _bathrooms,
      'isFurnished': _isFurnished,
      'hasElevator': _hasElevator,
      'hasParking': _hasParking,
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'شقة للإيجار في ${_districtController.text}',
      'countryId': 1,
      'governorateId': 1,
      'cityId': 1,
      'propertyType': 'APARTMENT',
    });

    if (mounted) {
      setState(() => _isPublishing = false);
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال العقار بنجاح وهو قيد المراجعة السريعة للنشر'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.failure?.message ?? 'فشل إضافة العقار'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة وحدة سكنية جديدة'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Step Indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepCircle(0, 'البيانات الأساسية'),
                    _buildStepLine(0),
                    _buildStepCircle(1, 'المواصفات'),
                    _buildStepLine(1),
                    _buildStepCircle(2, 'الوصف الذكي'),
                  ],
                ),
              ),
              const Divider(),

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingLg),
                  child: _buildCurrentStep(),
                ),
              ),

              // Bottom Actions
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMd),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: const Text('السابق'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        text: _currentStep == 2 ? 'نشر العقار' : 'التالي',
                        isLoading: _isPublishing,
                        onPressed: () {
                          if (_currentStep < 2) {
                            setState(() => _currentStep++);
                          } else {
                            _publishProperty();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int stepIndex, String title) {
    final isDone = _currentStep > stepIndex;
    final isCurrent = _currentStep == stepIndex;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? AppColors.primary
                : isDone
                    ? AppColors.success
                    : AppColors.border,
          ),
          child: Center(
            child: isDone
                ? const Icon(LucideIcons.check, size: 16, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isCurrent ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int stepIndex) {
    final isPassed = _currentStep > stepIndex;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isPassed ? AppColors.success : AppColors.border,
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'عنوان الإعلان',
              hint: 'مثال: شقة مفروشة 3 غرف في حي الجامعة',
              controller: _titleController,
              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            AppTextField(
              label: 'المنطقة / الحي (المنصورة)',
              hint: 'مثال: حي الجامعة',
              controller: _districtController,
              prefixIcon: const Icon(LucideIcons.map_pin, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            AppTextField(
              label: 'العنوان التفصيلي (محمي ومخفي حتى قبول المطابقة)',
              hint: 'مثال: شارع جيهان، برج الأطباء، الدور الرابع',
              controller: _addressController,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'الإيجار الشهري (ج.م)',
                    controller: _rentController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(LucideIcons.coins, size: 18),
                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'المساحة (م²)',
                    controller: _areaController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(LucideIcons.maximize_2, size: 18),
                    validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  ),
                ),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('عدد غرف النوم', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3, 4, 5].map((cnt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text('$cnt'),
                      selected: _bedrooms == cnt,
                      selectedColor: AppColors.accent,
                      labelStyle: TextStyle(
                        color: _bedrooms == cnt ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _bedrooms = cnt),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Text('عدد الحمامات', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3].map((cnt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$cnt'),
                      selected: _bathrooms == cnt,
                      selectedColor: AppColors.accent,
                      labelStyle: TextStyle(
                        color: _bathrooms == cnt ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _bathrooms = cnt),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            SwitchListTile(
              title: const Text('مفروشة بالكامل', style: TextStyle(fontSize: 14)),
              value: _isFurnished,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => setState(() => _isFurnished = v),
            ),
            SwitchListTile(
              title: const Text('يوجد مصعد بالعقار', style: TextStyle(fontSize: 14)),
              value: _hasElevator,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => setState(() => _hasElevator = v),
            ),
            SwitchListTile(
              title: const Text('يوجد موقف سيارات', style: TextStyle(fontSize: 14)),
              value: _hasParking,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => setState(() => _hasParking = v),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'استخدم الذكاء الاصطناعي لصياغة وصف تسويقي احترافي ودقيق بناءً على مواصفات شقتك',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            AppButton(
              text: 'توليد وتحسين الوصف بالذكاء الاصطناعي',
              icon: const Icon(LucideIcons.sparkles, size: 18, color: Colors.white),
              isLoading: _isOptimizingAi,
              onPressed: _generateAiDescription,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            AppTextField(
              label: 'وصف العقار التسويقي (يمكنك التعديل عليه)',
              hint: 'اكتب تفاصيل إضافية عن العقار أو استخدم زر التوليد الذكي أعلاه...',
              controller: _descriptionController,
              maxLines: 5,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
