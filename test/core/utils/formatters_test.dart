import 'package:flutter_test/flutter_test.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    test('formatCurrency formats numbers with thousands comma and EGP suffix', () {
      expect(Formatters.formatCurrency(8500), equals('8,500 ج.م'));
      expect(Formatters.formatCurrency(1200000), equals('1,200,000 ج.م'));
    });

    test('formatArea formats area in square meters', () {
      expect(Formatters.formatArea(150), equals('150 م²'));
    });

    test('phone validator validates Egyptian mobile numbers', () {
      expect(Formatters.isValidEgyptianPhone('01012345678'), isTrue);
      expect(Formatters.isValidEgyptianPhone('01123456789'), isTrue);
      expect(Formatters.isValidEgyptianPhone('01234567890'), isTrue);
      expect(Formatters.isValidEgyptianPhone('01567890123'), isTrue);
      expect(Formatters.isValidEgyptianPhone('+201012345678'), isTrue);

      expect(Formatters.isValidEgyptianPhone('01312345678'), isFalse);
      expect(Formatters.isValidEgyptianPhone('123456'), isFalse);
      expect(Formatters.isValidEgyptianPhone(''), isFalse);
    });

    test('email validator correctly identifies valid emails', () {
      expect(Formatters.isValidEmail('tenant@example.com'), isTrue);
      expect(Formatters.isValidEmail('landlord@propmatch.com'), isTrue);
      expect(Formatters.isValidEmail('not-an-email'), isFalse);
      expect(Formatters.isValidEmail('@empty.com'), isFalse);
    });
  });
}
