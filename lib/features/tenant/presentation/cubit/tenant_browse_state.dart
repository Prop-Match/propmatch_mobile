import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/property_entity.dart';

part 'tenant_browse_state.freezed.dart';

@freezed
class TenantBrowseState with _$TenantBrowseState {
  const factory TenantBrowseState.initial() = TenantBrowseInitial;
  const factory TenantBrowseState.loading() = TenantBrowseLoading;
  const factory TenantBrowseState.loaded({
    required List<PropertyEntity> properties,
    String? currentQuery,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
  }) = TenantBrowseLoaded;
  const factory TenantBrowseState.error(String message) = TenantBrowseError;
}
