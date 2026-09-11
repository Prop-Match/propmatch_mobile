import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import '../../domain/entities/user_entity.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.tenant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingMd),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      LucideIcons.house,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMd),
              Text(
                'الخطوة 1: اختر نوع حسابك',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.paddingSm),
              Text(
                'حدد ما إذا كنت تبحث عن عقار للإيجار أو مالكاً ترغب في تأجير وحداتك',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.paddingLg),
              _buildRoleCard(
                role: UserRole.tenant,
                title: 'مستأجر',
                description: 'ابحث عن شقتك المثالية أو انشر طلبك السكني وتلقى عروض الملاك المباشرة',
                icon: LucideIcons.user_check,
              ),
              const SizedBox(height: AppConstants.paddingMd),
              _buildRoleCard(
                role: UserRole.landlord,
                title: 'مالك عقار',
                description: 'اعرض وحداتك السكنية، حسّن الوصف بالذكاء الاصطناعي، وقدّم عروضك للمستأجرين',
                icon: LucideIcons.building,
              ),
              const Spacer(),
              AppButton(
                text: 'متابعة إلى بيانات التسجيل',
                onPressed: () {
                  context.push(AppRoutes.register, extra: _selectedRole);
                },
              ),
              const SizedBox(height: AppConstants.paddingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب بالفعل؟',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.login);
                      }
                    },
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingSm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.accent : AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          height: 1.35,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                LucideIcons.circle_check,
                color: AppColors.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
