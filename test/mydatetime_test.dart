
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/functions/mydatetime.dart';

void main() {
  group('mydatetime', () {
    test('convert 1-9-2023 and 1:30 pm correctly', () {
      final result = mydatetime('1-9-2023', '1:30 pm');
      expect(result, DateTime.parse('2023-09-01 13:30:00'));
    });
    test('convert 1-9-2023 and 12:30 pm correctly', () {
      final result = mydatetime('1-9-2023', '12:30 pm');
      expect(result, DateTime.parse('2023-09-01 12:30:00'));
    });

    test('midnight (12:00 am) is parsed correctly', () {
      final result = mydatetime('1-1-2023', '12:00 am');
      expect(result, DateTime.parse('2023-01-01 00:00:00'));
    });

    test('noon (12:00 pm) is parsed correctly', () {
      final result = mydatetime('1-1-2023', '12:00 pm');
      expect(result, DateTime.parse('2023-01-01 12:00:00'));
    });

    test('morning time (9:15 am)', () {
      final result = mydatetime('15-3-2023', '9:15 am');
      expect(result, DateTime.parse('2023-03-15 09:15:00'));
    });

    test('afternoon time (2:45 pm)', () {
      final result = mydatetime('7-10-2023', '2:45 pm');
      expect(result, DateTime.parse('2023-10-07 14:45:00'));
    });

    test('edge case - 12:59 am', () {
      final result = mydatetime('31-12-2023', '12:59 am');
      expect(result, DateTime.parse('2023-12-31 00:59:00'));
    });

    test('edge case - 12:59 pm', () {
      final result = mydatetime('31-12-2023', '12:59 pm');
      expect(result, DateTime.parse('2023-12-31 12:59:00'));
    });

    test('single digit day and month are padded correctly', () {
      final result = mydatetime('3-4-2023', '10:00 am');
      expect(result, DateTime.parse('2023-04-03 10:00:00'));
    });

    test('evening time (6:00 pm)', () {
      final result = mydatetime('25-8-2023', '6:00 pm');
      expect(result, DateTime.parse('2023-08-25 18:00:00'));
    });

    test('early morning (1:01 am)', () {
      final result = mydatetime('9-9-2023', '1:01 am');
      expect(result, DateTime.parse('2023-09-09 01:01:00'));
    });

    test('late night (11:59 pm)', () {
      final result = mydatetime('31-12-2023', '11:59 pm');
      expect(result, DateTime.parse('2023-12-31 23:59:00'));
    });
  });
}
