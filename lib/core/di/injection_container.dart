import 'package:get_it/get_it.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';
// Auth
import 'package:propmatch_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:propmatch_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:propmatch_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:propmatch_mobile/features/auth/presentation/cubit/auth_cubit.dart';
// Landlord
import 'package:propmatch_mobile/features/landlord/data/datasources/landlord_remote_datasource.dart';
import 'package:propmatch_mobile/features/landlord/data/repositories/landlord_repository_impl.dart';
import 'package:propmatch_mobile/features/landlord/domain/repositories/landlord_repository.dart';
import 'package:propmatch_mobile/features/landlord/presentation/cubit/landlord_dashboard_cubit.dart';
// Tenant
import 'package:propmatch_mobile/features/tenant/data/datasources/tenant_remote_datasource.dart';
import 'package:propmatch_mobile/features/tenant/data/repositories/tenant_repository_impl.dart';
import 'package:propmatch_mobile/features/tenant/domain/repositories/tenant_repository.dart';
import 'package:propmatch_mobile/features/tenant/presentation/cubit/tenant_browse_cubit.dart';
// Matching & Chat
import 'package:propmatch_mobile/features/matching_chat/data/datasources/chat_remote_datasource.dart';
import 'package:propmatch_mobile/features/matching_chat/data/repositories/chat_repository_impl.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/repositories/chat_repository.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/cubit/chat_cubit.dart';
// eKYC
import 'package:propmatch_mobile/features/ekyc/data/datasources/ekyc_remote_datasource.dart';
import 'package:propmatch_mobile/features/ekyc/data/repositories/ekyc_repository_impl.dart';
import 'package:propmatch_mobile/features/ekyc/domain/repositories/ekyc_repository.dart';
import 'package:propmatch_mobile/features/ekyc/presentation/cubit/ekyc_cubit.dart';
// Notifications
import 'package:propmatch_mobile/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:propmatch_mobile/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:propmatch_mobile/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:propmatch_mobile/features/notifications/presentation/cubit/notifications_cubit.dart';
// Subscriptions & Commercial
import 'package:propmatch_mobile/features/subscriptions/data/datasources/commercial_remote_datasource.dart';
import 'package:propmatch_mobile/features/subscriptions/data/repositories/commercial_repository_impl.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/repositories/commercial_repository.dart';
import 'package:propmatch_mobile/features/subscriptions/presentation/cubit/commercial_cubit.dart';
// Legal Support
import 'package:propmatch_mobile/features/legal_support/data/datasources/legal_support_remote_datasource.dart';
import 'package:propmatch_mobile/features/legal_support/data/repositories/legal_support_repository_impl.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/legal_support_repository.dart';
import 'package:propmatch_mobile/features/legal_support/presentation/cubit/legal_support_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // -------------------------------------------------------------
  // Core / External
  // -------------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      storageService: sl<SharedPreferencesService>(),
      baseUrl: ApiEndpoints.defaultBaseUrl,
    ),
  );

  // -------------------------------------------------------------
  // Feature: Auth
  // -------------------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      storageService: sl<SharedPreferencesService>(),
    ),
  );
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(repository: sl<AuthRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Tenant
  // -------------------------------------------------------------
  sl.registerLazySingleton<TenantRemoteDataSource>(
    () => TenantRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<TenantRepository>(
    () => TenantRepositoryImpl(sl<TenantRemoteDataSource>()),
  );
  sl.registerFactory<TenantBrowseCubit>(
    () => TenantBrowseCubit(repository: sl<TenantRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Landlord
  // -------------------------------------------------------------
  sl.registerLazySingleton<LandlordRemoteDataSource>(
    () => LandlordRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<LandlordRepository>(
    () => LandlordRepositoryImpl(sl<LandlordRemoteDataSource>()),
  );
  sl.registerFactory<LandlordDashboardCubit>(
    () => LandlordDashboardCubit(repository: sl<LandlordRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Matching & Chat
  // -------------------------------------------------------------
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
  );
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(repository: sl<ChatRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: eKYC
  // -------------------------------------------------------------
  sl.registerLazySingleton<EkycRemoteDataSource>(
    () => EkycRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<EkycRepository>(
    () => EkycRepositoryImpl(sl<EkycRemoteDataSource>()),
  );
  sl.registerFactory<EkycCubit>(
    () => EkycCubit(repository: sl<EkycRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Notifications
  // -------------------------------------------------------------
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl<NotificationsRemoteDataSource>()),
  );
  sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(repository: sl<NotificationsRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Subscriptions & Commercial
  // -------------------------------------------------------------
  sl.registerLazySingleton<CommercialRemoteDataSource>(
    () => CommercialRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<CommercialRepository>(
    () => CommercialRepositoryImpl(sl<CommercialRemoteDataSource>()),
  );
  sl.registerFactory<CommercialCubit>(
    () => CommercialCubit(repository: sl<CommercialRepository>()),
  );

  // -------------------------------------------------------------
  // Feature: Legal Support
  // -------------------------------------------------------------
  sl.registerLazySingleton<LegalSupportRemoteDataSource>(
    () => LegalSupportRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<LegalSupportRepository>(
    () => LegalSupportRepositoryImpl(sl<LegalSupportRemoteDataSource>()),
  );
  sl.registerFactory<LegalSupportCubit>(
    () => LegalSupportCubit(repository: sl<LegalSupportRepository>()),
  );
}
