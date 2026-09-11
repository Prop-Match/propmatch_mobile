import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/landlord/domain/repositories/landlord_repository.dart';
import 'landlord_dashboard_state.dart';

export 'landlord_dashboard_state.dart';

class LandlordDashboardCubit extends Cubit<LandlordDashboardState> {
  final LandlordRepository repository;

  LandlordDashboardCubit({required this.repository}) : super(const LandlordDashboardState.initial());

  Future<void> loadDashboard() async {
    emit(const LandlordDashboardState.loading());
    final result = await repository.getDashboardData();
    if (result.isSuccess && result.data != null) {
      emit(LandlordDashboardState.loaded(result.data!));
    } else {
      emit(LandlordDashboardState.error(result.failure?.message ?? 'فشل تحميل لوحة التحكم'));
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    final result = await repository.deleteProperty(propertyId);
    if (result.isSuccess) {
      loadDashboard();
    }
  }
}
