import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/tenant_repository.dart';
import 'tenant_browse_state.dart';

export 'tenant_browse_state.dart';

class TenantBrowseCubit extends Cubit<TenantBrowseState> {
  final TenantRepository repository;

  TenantBrowseCubit({required this.repository}) : super(const TenantBrowseState.initial());

  Future<void> loadProperties({
    String? query,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
  }) async {
    emit(const TenantBrowseState.loading());
    final result = await repository.getProperties(
      query: query,
      minPrice: minPrice,
      maxPrice: maxPrice,
      bedrooms: bedrooms,
      isFurnished: isFurnished,
      district: district,
    );

    if (result.isSuccess && result.data != null) {
      emit(TenantBrowseState.loaded(
        properties: result.data!,
        currentQuery: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        bedrooms: bedrooms,
        isFurnished: isFurnished,
        district: district,
      ));
    } else {
      emit(TenantBrowseState.error(result.failure?.message ?? 'فشل تحميل العقارات'));
    }
  }

  Future<void> toggleFavorite(String propertyId) async {
    if (state is TenantBrowseLoaded) {
      final current = state as TenantBrowseLoaded;
      final updatedList = current.properties.map((p) {
        if (p.id == propertyId) {
          return PropertyEntity(
            id: p.id,
            title: p.title,
            description: p.description,
            rentAmount: p.rentAmount,
            areaM2: p.areaM2,
            bedrooms: p.bedrooms,
            bathrooms: p.bathrooms,
            isFurnished: p.isFurnished,
            hasElevator: p.hasElevator,
            hasParking: p.hasParking,
            district: p.district,
            cityName: p.cityName,
            governorateName: p.governorateName,
            manualAddress: p.manualAddress,
            coverImageUrl: p.coverImageUrl,
            images: p.images,
            isBoosted: p.isBoosted,
            matchScore: p.matchScore,
            matchBreakdown: p.matchBreakdown,
            ownerId: p.ownerId,
            ownerName: p.ownerName,
            ownerPhone: p.ownerPhone,
            isOwnerVerified: p.isOwnerVerified,
            contactRevealed: p.contactRevealed,
            isFavorite: !p.isFavorite,
          );
        }
        return p;
      }).toList();

      emit(TenantBrowseState.loaded(
        properties: updatedList,
        currentQuery: current.currentQuery,
        minPrice: current.minPrice,
        maxPrice: current.maxPrice,
        bedrooms: current.bedrooms,
        isFurnished: current.isFurnished,
        district: current.district,
      ));

      await repository.toggleFavorite(propertyId);
    }
  }
}
