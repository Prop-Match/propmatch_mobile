import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

export 'app_routes.dart';

import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:propmatch_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:propmatch_mobile/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:propmatch_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:propmatch_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:propmatch_mobile/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:propmatch_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/repositories/tenant_repository.dart';
import 'package:propmatch_mobile/features/tenant/presentation/screens/tenant_main_screen.dart';
import 'package:propmatch_mobile/features/tenant/presentation/screens/property_detail_screen.dart';
import 'package:propmatch_mobile/features/tenant/presentation/screens/post_tenant_request_screen.dart';
import 'package:propmatch_mobile/features/landlord/presentation/screens/landlord_main_screen.dart';
import 'package:propmatch_mobile/features/landlord/presentation/screens/add_property_wizard_screen.dart';
import 'package:propmatch_mobile/features/landlord/presentation/screens/landlord_leads_screen.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/match_connection_entity.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/screens/chat_room_screen.dart';
import 'package:propmatch_mobile/features/ekyc/presentation/screens/ekyc_verification_screen.dart';
import 'package:propmatch_mobile/features/legal_support/presentation/screens/legal_assistant_screen.dart';
import 'package:propmatch_mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:propmatch_mobile/features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter({required String initialLocation}) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      redirect: (context, state) {
        final authRepo = sl<AuthRepository>();
        final user = authRepo.getCachedUser();
        final isAuth = user != null;

        final isAuthRoute = state.matchedLocation == AppRoutes.roleSelect ||
            state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register ||
            state.matchedLocation == AppRoutes.otpVerification ||
            state.matchedLocation == AppRoutes.forgotPassword;

        // Deep links like /properties/:id or /tenant-requests/:id are public or semi-public
        final isPublicDeepLink = state.matchedLocation.startsWith('/properties/') ||
            state.matchedLocation.startsWith('/tenant-requests/');

        if (!isAuth && !isAuthRoute && !isPublicDeepLink) {
          return AppRoutes.login;
        }

        if (isAuth && isAuthRoute) {
          return user.role == UserRole.landlord ? AppRoutes.landlord : AppRoutes.tenant;
        }

        // Role guards
        if (isAuth) {
          if (user.role == UserRole.tenant && state.matchedLocation.startsWith(AppRoutes.landlord)) {
            return AppRoutes.tenant;
          }
          if (user.role == UserRole.landlord && state.matchedLocation == AppRoutes.tenant) {
            return AppRoutes.landlord;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.roleSelect,
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) {
            final role = state.extra is UserRole ? state.extra as UserRole : UserRole.tenant;
            return RegisterScreen(initialRole: role);
          },
        ),
        GoRoute(
          path: AppRoutes.otpVerification,
          builder: (context, state) {
            final email = state.extra is String ? state.extra as String : '';
            return OtpVerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Deep link handler for /properties/:id
        GoRoute(
          path: AppRoutes.propertyDeepLink,
          builder: (context, state) {
            final propertyId = state.pathParameters['id']!;
            if (state.extra is PropertyEntity) {
              return PropertyDetailScreen(property: state.extra as PropertyEntity);
            }
            return _AsyncPropertyDetailScreen(propertyId: propertyId);
          },
        ),

        // Tenant Routes
        GoRoute(
          path: AppRoutes.tenant,
          builder: (context, state) => const TenantMainScreen(),
        ),
        GoRoute(
          path: AppRoutes.tenantProperty,
          builder: (context, state) {
            final propertyId = state.pathParameters['id']!;
            if (state.extra is PropertyEntity) {
              return PropertyDetailScreen(property: state.extra as PropertyEntity);
            }
            return _AsyncPropertyDetailScreen(propertyId: propertyId);
          },
        ),
        GoRoute(
          path: AppRoutes.tenantPostRequest,
          builder: (context, state) => const PostTenantRequestScreen(),
        ),

        // Landlord Routes
        GoRoute(
          path: AppRoutes.landlord,
          builder: (context, state) => const LandlordMainScreen(),
        ),
        GoRoute(
          path: AppRoutes.landlordAddProperty,
          builder: (context, state) => const AddPropertyWizardScreen(),
        ),
        GoRoute(
          path: AppRoutes.landlordLeads,
          builder: (context, state) => const LandlordLeadsScreen(),
        ),

        // Shared / Feature Routes
        GoRoute(
          path: AppRoutes.chat,
          builder: (context, state) {
            final connection = state.extra as MatchConnectionEntity;
            return ChatRoomScreen(connection: connection);
          },
        ),
        GoRoute(
          path: AppRoutes.ekyc,
          builder: (context, state) => const EkycVerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.legalAssistant,
          builder: (context, state) => const LegalAssistantScreen(),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}

class _AsyncPropertyDetailScreen extends StatelessWidget {
  final String propertyId;

  const _AsyncPropertyDetailScreen({required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PropertyEntity?>(
      future: sl<TenantRepository>().getPropertyById(propertyId).then((res) => res.data),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return PropertyDetailScreen(property: snapshot.data!);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('تفاصيل العقار')),
          body: const Center(child: Text('لم يتم العثور على العقار المطلوب')),
        );
      },
    );
  }
}
