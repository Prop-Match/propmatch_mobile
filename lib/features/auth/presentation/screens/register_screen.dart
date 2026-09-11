import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/app_text_field.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole initialRole;

  const RegisterScreen({
    super.key,
    this.initialRole = UserRole.tenant,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleTitle = _selectedRole == UserRole.landlord ? 'مالك عقار' : 'مستأجر';

    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب $roleTitle'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            if (state.user.role == UserRole.landlord) {
              context.go(AppRoutes.landlord);
            } else {
              context.go(AppRoutes.tenant);
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSm),
                    Text(
                      'انضم إلى PropMatch AI',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أدخل بياناتك لإنشاء حسابك كـ $roleTitle والبدء فوراً',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.paddingLg),
                    AppTextField(
                      label: 'الاسم الكامل',
                      hint: 'مثال: محمد علي',
                      controller: _fullNameController,
                      prefixIcon: const Icon(LucideIcons.user, size: 20),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMd),
                    AppTextField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(LucideIcons.mail, size: 20),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!Formatters.isValidEmail(value)) {
                          return 'صيغة البريد الإلكتروني غير صحيحة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMd),
                    AppTextField(
                      label: 'رقم الهاتف المصري',
                      hint: '01012345678',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(LucideIcons.phone, size: 20),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        if (!Formatters.isValidEgyptianPhone(value)) {
                          return 'رقم هاتف مصري غير صحيح (يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMd),
                    AppTextField(
                      label: 'كلمة المرور',
                      hint: '••••••••',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(LucideIcons.lock, size: 20),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMd),
                    AppTextField(
                      label: 'تأكيد كلمة المرور',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: const Icon(LucideIcons.lock, size: 20),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLg),
                    AppButton(
                      text: 'إنشاء الحساب',
                      isLoading: isLoading,
                      onPressed: _submit,
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
                            context.pop();
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
