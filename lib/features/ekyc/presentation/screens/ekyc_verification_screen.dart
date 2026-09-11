import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/ownership_disclaimer_widget.dart';

class EkycVerificationScreen extends StatefulWidget {
  const EkycVerificationScreen({super.key});

  @override
  State<EkycVerificationScreen> createState() => _EkycVerificationScreenState();
}

class _EkycVerificationScreenState extends State<EkycVerificationScreen> {
  bool _hasFrontId = false;
  bool _hasBackId = false;
  bool _hasSelfie = false;
  bool _isSubmitted = false;

  void _simulateUpload(String type) {
    setState(() {
      if (type == 'front') _hasFrontId = true;
      if (type == 'back') _hasBackId = true;
      if (type == 'selfie') _hasSelfie = true;
    });
  }

  void _submitForReview() {
    if (_hasFrontId && _hasBackId && _hasSelfie) {
      setState(() {
        _isSubmitted = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى التقاط وتجهيز كافة المستندات المطلوبة (الوجه الأمامي، الخلفي، والسيلفي)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('توثيق الهوية الوطنية'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLg),
          child: _isSubmitted ? _buildSubmittedView() : _buildUploadFlow(),
        ),
      ),
    );
  }

  Widget _buildUploadFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OwnershipDisclaimerWidget(),
        const SizedBox(height: AppConstants.paddingLg),

        Text(
          'خطوات توثيق الهوية',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'التقط صوراً واضحة لبطاقة الرقم القومي المصرية وصورة سيلفي مباشرة لتأكيد حسابك',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppConstants.paddingLg),

        _buildDocCard(
          title: 'بطاقة الرقم القومي (الوجه الأمامي)',
          isUploaded: _hasFrontId,
          icon: LucideIcons.credit_card,
          onTap: () => _simulateUpload('front'),
        ),
        const SizedBox(height: AppConstants.paddingMd),

        _buildDocCard(
          title: 'بطاقة الرقم القومي (الوجه الخلفي)',
          isUploaded: _hasBackId,
          icon: LucideIcons.credit_card,
          onTap: () => _simulateUpload('back'),
        ),
        const SizedBox(height: AppConstants.paddingMd),

        _buildDocCard(
          title: 'صورة شخصية حية (سيلفي)',
          isUploaded: _hasSelfie,
          icon: LucideIcons.camera,
          onTap: () => _simulateUpload('selfie'),
        ),
        const SizedBox(height: AppConstants.paddingXl),

        AppButton(
          text: 'إرسال المستندات للتحقق',
          onPressed: _submitForReview,
        ),
      ],
    );
  }

  Widget _buildDocCard({
    required String title,
    required bool isUploaded,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUploaded ? AppColors.success.withValues(alpha: 0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(
                icon,
                color: isUploaded ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
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
                    isUploaded ? 'تم تجهيز الصورة بنجاح' : 'اضغط لالتقاط الصورة',
                    style: TextStyle(
                      color: isUploaded ? AppColors.success : AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded ? LucideIcons.circle_check : LucideIcons.circle_plus,
              color: isUploaded ? AppColors.success : AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.clock, size: 54, color: AppColors.warning),
        ),
        const SizedBox(height: AppConstants.paddingLg),
        const Text(
          'المستندات قيد المراجعة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'تم استلام بطاقة الرقم القومي والصورة الشخصية بنجاح. يقوم فريق التحقق بمراجعة الطلب وسيتم تفعيل شارة التوثيق لحسابك فور الاعتماد.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14),
        ),
        const SizedBox(height: AppConstants.paddingXl),
        const OwnershipDisclaimerWidget(),
        const SizedBox(height: AppConstants.paddingXl),
        AppButton(
          text: 'العودة للصفحة الرئيسية',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
