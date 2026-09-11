import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';

part 'landlord_dashboard_state.freezed.dart';

@freezed
class LandlordDashboardState with _$LandlordDashboardState {
  const factory LandlordDashboardState.initial() = LandlordDashboardInitial;
  const factory LandlordDashboardState.loading() = LandlordDashboardLoading;
  const factory LandlordDashboardState.loaded(LandlordDashboardData data) = LandlordDashboardLoaded;
  const factory LandlordDashboardState.error(String message) = LandlordDashboardError;
}
