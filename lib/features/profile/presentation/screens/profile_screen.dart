import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          final roleTitle = user?.role == UserRole.landlord ? 'مالك عقار' : 'مستأجر';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Column(
                children: [
                  // User Avatar & Name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (user?.fullName.isNotEmpty ?? false)
                                ? user!.fullName.substring(0, 1)
                                : 'م',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user?.fullName ?? 'المستخدم',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (user?.isIdentityVerified ?? false) ...[
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.circle_check, color: AppColors.accent, size: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            roleTitle,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXl),

                  // Menu Options
                  _buildProfileTile(
                    icon: LucideIcons.shield_check,
                    title: 'توثيق الهوية الوطنية (eKYC)',
                    subtitle: user?.isIdentityVerified ?? false
                        ? 'تم توثيق الهوية'
                        : 'وثّق هويتك لزيادة الموثوقية',
                    onTap: () => context.push(AppRoutes.ekyc),
                  ),
                  _buildProfileTile(
                    icon: LucideIcons.scale,
                    title: 'المساعد القانوني الذكي',
                    subtitle: 'استشارات قانون الإيجارات المصري والبنود',
                    onTap: () => context.push(AppRoutes.legalAssistant),
                  ),
                  if (user?.role == UserRole.landlord)
                    _buildProfileTile(
                      icon: LucideIcons.crown,
                      title: 'الباقات والاشتراكات',
                      subtitle: 'إدارة الباقة وترقية الحساب وطلب Boost',
                      onTap: () => context.push(AppRoutes.paymentsPlans),
                    ),
                  _buildProfileTile(
                    icon: LucideIcons.bell,
                    title: 'مركز الإشعارات',
                    subtitle: 'تنبيهات العروض والمطابقات والرسائل',
                    onTap: () => context.push(AppRoutes.notifications),
                  ),
                  const SizedBox(height: AppConstants.paddingMd),
                  const Divider(),
                  const SizedBox(height: AppConstants.paddingMd),

                  // Logout
                  ListTile(
                    leading: const Icon(LucideIcons.log_out, color: AppColors.error),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      context.read<AuthCubit>().logout();
                      context.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: const Icon(LucideIcons.chevron_left, size: 18, color: AppColors.textMuted),
      ),
    );
  }
}
