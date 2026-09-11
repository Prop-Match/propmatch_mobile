import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

// Auth
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/domain/entities/user_entity.dart';

// Tenant
import 'features/tenant/domain/repositories/tenant_repository.dart';
import 'features/tenant/presentation/cubit/tenant_browse_cubit.dart';

// Landlord
import 'features/landlord/domain/repositories/landlord_repository.dart';
import 'features/landlord/presentation/cubit/landlord_dashboard_cubit.dart';

// Matching & Chat
import 'features/matching_chat/domain/repositories/chat_repository.dart';
import 'features/matching_chat/presentation/cubit/chat_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize GetIt dependency injection container
  await initDependencies();

  // Determine initial location based on cached session
  final authRepository = sl<AuthRepository>();
  final cachedUser = authRepository.getCachedUser();
  String initialLocation = AppRoutes.login;
  if (cachedUser != null) {
    initialLocation = cachedUser.role == UserRole.landlord ? AppRoutes.landlord : AppRoutes.tenant;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: PropMatchApp(initialLocation: initialLocation),
    ),
  );
}

class PropMatchApp extends StatelessWidget {
  final String initialLocation;

  const PropMatchApp({
    super.key,
    required this.initialLocation,
  });

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(initialLocation: initialLocation);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: sl<AuthRepository>()),
        RepositoryProvider<TenantRepository>.value(value: sl<TenantRepository>()),
        RepositoryProvider<LandlordRepository>.value(value: sl<LandlordRepository>()),
        RepositoryProvider<ChatRepository>.value(value: sl<ChatRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => sl<AuthCubit>()..checkAuthStatus(),
          ),
          BlocProvider<TenantBrowseCubit>(
            create: (context) => sl<TenantBrowseCubit>(),
          ),
          BlocProvider<LandlordDashboardCubit>(
            create: (context) => sl<LandlordDashboardCubit>(),
          ),
          BlocProvider<ChatCubit>(
            create: (context) => sl<ChatCubit>(),
          ),
        ],
        child: MaterialApp.router(
          title: 'PropMatch AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: router,
        ),
      ),
    );
  }
}
