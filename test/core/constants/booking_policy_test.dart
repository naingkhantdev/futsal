import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/booking_policy.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';

void main() {
  test('pending and confirmed block availability; others do not', () {
    expect(BookingPolicy.blocksAvailability(BookingStatus.pending), isTrue);
    expect(BookingPolicy.blocksAvailability(BookingStatus.confirmed), isTrue);
    expect(BookingPolicy.blocksAvailability(BookingStatus.cancelled), isFalse);
    expect(BookingPolicy.blocksAvailability(BookingStatus.rejected), isFalse);
    expect(BookingPolicy.blocksAvailability(BookingStatus.completed), isFalse);
  });
}
