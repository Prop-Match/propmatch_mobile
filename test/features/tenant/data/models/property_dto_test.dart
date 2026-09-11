import 'package:flutter_test/flutter_test.dart';
import 'package:propmatch_mobile/features/tenant/data/models/property_dto.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';

void main() {
  final tPropertyJson = {
    'id': 'prop-123',
    'title': 'شقة فاخرة للإيجار بحي الجامعة',
    'description': 'شقة مميزة قريبة من الخدمات ومفروشة بالكامل',
    'rentAmount': 9500,
    'areaM2': 140,
    'bedrooms': 3,
    'bathrooms': 2,
    'isFurnished': true,
    'hasElevator': true,
    'hasParking': false,
    'district': 'حي الجامعة',
    'manualAddress': 'شارع جيهان، المنصورة',
    'contactRevealed': false,
    'status': 'APPROVED',
    'isBoosted': true,
    'matchScore': 88.5,
    'city': {'id': 1, 'nameAr': 'المنصورة'},
    'governorate': {'id': 1, 'nameAr': 'الدقهلية'},
    'propertyImages': [
      {'id': 'img-1', 'imageUrl': 'https://example.com/img1.jpg', 'isCover': true},
      {'id': 'img-2', 'imageUrl': 'https://example.com/img2.jpg', 'isCover': false},
    ],
    'owner': {
      'id': 'owner-1',
      'fullName': 'د. محمود سالم',
      'phoneNumber': '01000000000',
      'identityVerification': {'status': 'APPROVED'},
    },
  };

  group('PropertyDto', () {
    test('fromJson correctly parses property JSON with images and matchScore', () {
      final dto = PropertyDto.fromJson(tPropertyJson);

      expect(dto.id, equals('prop-123'));
      expect(dto.title, equals('شقة فاخرة للإيجار بحي الجامعة'));
      expect(dto.rentAmount, equals(9500));
      expect(dto.areaM2, equals(140));
      expect(dto.bedrooms, equals(3));
      expect(dto.bathrooms, equals(2));
      expect(dto.isFurnished, isTrue);
      expect(dto.hasElevator, isTrue);
      expect(dto.hasParking, isFalse);
      expect(dto.district, equals('حي الجامعة'));
      expect(dto.cityName, equals('المنصورة'));
      expect(dto.isBoosted, isTrue);
      expect(dto.matchScore, equals(88.5));
      expect(dto.coverImageUrl, equals('https://example.com/img1.jpg'));
      expect(dto.images.length, equals(2));
      expect(dto.ownerName, equals('د. محمود سالم'));
      expect(dto.isOwnerVerified, isTrue);
      expect(dto.contactRevealed, isFalse);
    });

    test('should be a subclass of PropertyEntity', () {
      final dto = PropertyDto.fromJson(tPropertyJson);
      expect(dto, isA<PropertyEntity>());
    });
  });
}
