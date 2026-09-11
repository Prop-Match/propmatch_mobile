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
// Matching & Chat
import 'package:propmatch_mobile/features/matching_chat/data/datasources/chat_remote_datasource.dart';
import 'package:propmatch_mobile/features/matching_chat/data/repositories/chat_repository_impl.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/repositories/chat_repository.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/cubit/chat_cubit.dart';
// Tenant
import 'package:propmatch_mobile/features/tenant/data/datasources/tenant_remote_datasource.dart';
import 'package:propmatch_mobile/features/tenant/data/repositories/tenant_repository_impl.dart';
import 'package:propmatch_mobile/features/tenant/domain/repositories/tenant_repository.dart';
import 'package:propmatch_mobile/features/tenant/presentation/cubit/tenant_browse_cubit.dart';
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
}
