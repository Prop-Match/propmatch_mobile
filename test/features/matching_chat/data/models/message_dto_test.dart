import 'package:flutter_test/flutter_test.dart';
import 'package:propmatch_mobile/features/matching_chat/data/models/message_dto.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';

void main() {
  final tMessageJson = {
    'id': 'msg-1',
    'matchConnectionId': 'conn-1',
    'senderId': 'user-1',
    'body': 'السلام عليكم، هل الشقة متاحة للمعاينة غداً؟',
    'attachmentUrl': null,
    'attachmentType': null,
    'createdAt': '2026-08-30T10:00:00.000Z',
    'sender': {
      'id': 'user-1',
      'fullName': 'أحمد محمود',
    },
  };

  group('MessageDto', () {
    test('fromJson correctly parses message json', () {
      final dto = MessageDto.fromJson(tMessageJson);

      expect(dto.id, equals('msg-1'));
      expect(dto.matchConnectionId, equals('conn-1'));
      expect(dto.senderId, equals('user-1'));
      expect(dto.body, equals('السلام عليكم، هل الشقة متاحة للمعاينة غداً؟'));
      expect(dto.senderName, equals('أحمد محمود'));
      expect(dto, isA<MessageEntity>());
    });

    test('toJson serializes correctly', () {
      final dto = MessageDto.fromJson(tMessageJson);
      final json = dto.toJson();

      expect(json['matchConnectionId'], equals('conn-1'));
      expect(json['body'], equals('السلام عليكم، هل الشقة متاحة للمعاينة غداً؟'));
    });
  });
}
