import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/ownership_disclaimer_widget.dart';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';
import 'package:propmatch_mobile/features/ekyc/domain/repositories/ekyc_repository.dart';
import 'package:propmatch_mobile/features/ekyc/presentation/cubit/ekyc_cubit.dart';

class EkycVerificationScreen extends StatelessWidget {
  const EkycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EkycCubit(repository: sl<EkycRepository>())..fetchVerificationStatus(),
      child: const _EkycVerificationView(),
    );
  }
}

class _EkycVerificationView extends StatefulWidget {
  const _EkycVerificationView();

  @override
  State<_EkycVerificationView> createState() => _EkycVerificationViewState();
}

class _EkycVerificationViewState extends State<_EkycVerificationView> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _frontIdFile;
  File? _backIdFile;
  File? _selfieFile;

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختر مصدر الصورة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.paddingMd),
              ListTile(
                leading: const Icon(LucideIcons.camera, color: AppColors.primary),
                title: const Text('التقاط بواسطة الكاميرا'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final picked = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1600,
                    maxHeight: 1600,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    setState(() {
                      if (type == 'front') _frontIdFile = File(picked.path);
                      if (type == 'back') _backIdFile = File(picked.path);
                      if (type == 'selfie') _selfieFile = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image, color: AppColors.primary),
                title: const Text('اختيار من معرض الصور'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final picked = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1600,
                    maxHeight: 1600,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    setState(() {
                      if (type == 'front') _frontIdFile = File(picked.path);
                      if (type == 'back') _backIdFile = File(picked.path);
                      if (type == 'selfie') _selfieFile = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_frontIdFile == null || _backIdFile == null || _selfieFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى التقاط وتجهيز كافة المستندات المطلوبة (الوجه الأمامي، الخلفي، والسيلفي)'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<EkycCubit>().submitVerification(
          nationalId: _nationalIdController.text.trim(),
          nationalIdFront: _frontIdFile!,
          nationalIdBack: _backIdFile!,
          selfie: _selfieFile!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('توثيق الهوية الوطنية'),
      ),
      body: SafeArea(
        child: BlocConsumer<EkycCubit, EkycState>(
          listener: (context, state) {
            if (state is EkycError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is EkycSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال مستندات التحقق بنجاح!'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EkycLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            VerificationEntity? entity;
            if (state is EkycLoaded) {
              entity = state.verification;
            } else if (state is EkycSubmitSuccess) {
              entity = state.verification;
            } else if (state is EkycSubmitting) {
              entity = state.previousVerification;
            }

            if (entity != null) {
              if (entity.status == VerificationStatus.approved) {
                return _buildApprovedView(entity);
              }
              if (entity.status == VerificationStatus.pending) {
                return _buildPendingView(entity);
              }
              if (entity.status == VerificationStatus.rejected && !entity.canSubmit) {
                return _buildRejectedView(entity);
              }
            }

            final isSubmitting = state is EkycSubmitting;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Form(
                key: _formKey,
                child: _buildUploadFlow(entity, isSubmitting),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUploadFlow(VerificationEntity? entity, bool isSubmitting) {
    final isResubmission = entity?.status == VerificationStatus.resubmissionRequired;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OwnershipDisclaimerWidget(),
        const SizedBox(height: AppConstants.paddingLg),

        if (isResubmission && entity?.rejectionReason != null) ...[
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.circle_alert, color: AppColors.error, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مطلوب إعادة تقديم المستندات',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'سبب طلب إعادة التقديم: ${entity!.rejectionReason}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLg),
        ],

        Text(
          'خطوات توثيق الهوية',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'التوثيق مطلوب مرة واحدة لنشر العقارات وتقديم العروض. بطاقة الرقم القومي المصرية وصورة سيلفي حية.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppConstants.paddingLg),

        // National ID Field
        TextFormField(
          controller: _nationalIdController,
          keyboardType: TextInputType.number,
          maxLength: 14,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            labelText: 'الرقم القومي (14 رقم)',
            hintText: '2990101XXXXXXXXX',
            prefixIcon: const Icon(LucideIcons.fingerprint, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال الرقم القومي';
            }
            if (!RegExp(r'^\d{14}$').hasMatch(value.trim())) {
              return 'الرقم القومي يجب أن يتكون من 14 رقمًا بالضبط';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMd),

        _buildDocCard(
          title: 'بطاقة الرقم القومي (الوجه الأمامي)',
          hint: 'صوّر وجه البطاقة الأمامي بوضوح',
          file: _frontIdFile,
          icon: LucideIcons.credit_card,
          onTap: () => _pickImage('front'),
          onRemove: () => setState(() => _frontIdFile = null),
        ),
        const SizedBox(height: AppConstants.paddingMd),

        _buildDocCard(
          title: 'بطاقة الرقم القومي (الوجه الخلفي)',
          hint: 'صوّر وجه البطاقة الخلفي بوضوح',
          file: _backIdFile,
          icon: LucideIcons.credit_card,
          onTap: () => _pickImage('back'),
          onRemove: () => setState(() => _backIdFile = null),
        ),
        const SizedBox(height: AppConstants.paddingMd),

        _buildDocCard(
          title: 'صورة شخصية حية (سيلفي)',
          hint: 'التقط صورة شخصية واضحة للوجه',
          file: _selfieFile,
          icon: LucideIcons.camera,
          onTap: () => _pickImage('selfie'),
          onRemove: () => setState(() => _selfieFile = null),
        ),
        const SizedBox(height: AppConstants.paddingXl),

        AppButton(
          text: isSubmitting
              ? 'جارٍ إرسال المستندات...'
              : (isResubmission ? 'إعادة تقديم المستندات' : 'إرسال المستندات للتحقق'),
          isLoading: isSubmitting,
          onPressed: isSubmitting ? null : _submit,
        ),
      ],
    );
  }

  Widget _buildDocCard({
    required String title,
    required String hint,
    required File? file,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final isUploaded = file != null;

    return InkWell(
      onTap: isUploaded ? null : onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        decoration: BoxDecoration(
          color: isUploaded ? AppColors.success.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.border,
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isUploaded)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                child: Image.file(
                  file,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    isUploaded ? 'تم اختيار الصورة بنجاح' : hint,
                    style: TextStyle(
                      color: isUploaded ? AppColors.success : AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isUploaded)
              IconButton(
                icon: const Icon(LucideIcons.trash_2, color: AppColors.error, size: 20),
                onPressed: onRemove,
              )
            else
              const Icon(
                LucideIcons.circle_plus,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingView(VerificationEntity entity) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.pending.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.clock, size: 54, color: AppColors.pending),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            const Text(
              'طلب التوثيق قيد المراجعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'تم استلام بطاقة الرقم القومي والصورة الشخصية بنجاح. يقوم فريق العمل بمراجعة المستندات وسيتم إشعارك فور الاعتماد.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: AppConstants.paddingXl),
            const OwnershipDisclaimerWidget(),
            const SizedBox(height: AppConstants.paddingXl),
            AppButton(
              text: 'العودة',
              variant: AppButtonVariant.outline,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedView(VerificationEntity entity) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.badge_check, size: 54, color: AppColors.success),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            const Text(
              'تم توثيق هويتك بنجاح!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.success),
            ),
            const SizedBox(height: 8),
            const Text(
              'تم اعتماد بطاقة الرقم القومي وحسابك موثّق الآن ومؤهل لإتمام التعاقدات ونشر العقارات والعروض.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: AppConstants.paddingXl),
            const OwnershipDisclaimerWidget(),
            const SizedBox(height: AppConstants.paddingXl),
            AppButton(
              text: 'متابعة إلى التطبيق',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedView(VerificationEntity entity) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.circle_x, size: 54, color: AppColors.error),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            const Text(
              'تم رفض طلب التوثيق',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              entity.rejectionReason ?? 'تعذر قبول المستندات المرفقة.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: AppConstants.paddingXl),
            AppButton(
              text: 'العودة',
              variant: AppButtonVariant.outline,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
