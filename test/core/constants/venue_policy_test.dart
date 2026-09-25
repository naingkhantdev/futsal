import 'package:flutter_test/flutter_test.dart';
import 'package:futsal_booking/core/constants/domain_enums.dart';
import 'package:futsal_booking/core/constants/venue_policy.dart';

void main() {
  group('isPublished (mirror of firestore.rules stadiumPublished)', () {
    test('only active + listed shop with an active stadium', () {
      expect(
        VenuePolicy.isPublished(
          shopStatus: ShopStatus.active,
          shopIsListed: true,
          stadiumIsActive: true,
        ),
        isTrue,
      );
    });

    for (final status in ShopStatus.values.where((s) => s != ShopStatus.active)) {
      test('$status shop → hidden', () {
        expect(
          VenuePolicy.isPublished(
            shopStatus: status,
            shopIsListed: true,
            stadiumIsActive: true,
          ),
          isFalse,
        );
      });
    }

    test('unlisted shop or inactive stadium → hidden', () {
      expect(
        VenuePolicy.isPublished(
          shopStatus: ShopStatus.active,
          shopIsListed: false,
          stadiumIsActive: true,
        ),
        isFalse,
      );
      expect(
        VenuePolicy.isPublished(
          shopStatus: ShopStatus.active,
          shopIsListed: true,
          stadiumIsActive: false,
        ),
        isFalse,
      );
    });
  });

  group('minHourlyPrice', () {
    test('lowest price among active, priced courts', () {
      expect(
        VenuePolicy.minHourlyPrice([
          (isActive: true, hourlyPrice: 30000),
          (isActive: false, hourlyPrice: 10000),
          (isActive: true, hourlyPrice: null),
          (isActive: true, hourlyPrice: 25000),
        ]),
        25000,
      );
    });

    test('null when no active priced court', () {
      expect(VenuePolicy.minHourlyPrice(const []), isNull);
      expect(
        VenuePolicy.minHourlyPrice([(isActive: false, hourlyPrice: 1)]),
        isNull,
      );
    });

    test('a free court (0) counts', () {
      expect(
        VenuePolicy.minHourlyPrice([
          (isActive: true, hourlyPrice: 0),
          (isActive: true, hourlyPrice: 5000),
        ]),
        0,
      );
    });
  });

  test('slot lengths keep the grid fixed: each divides an hour', () {
    for (final m in VenuePolicy.allowedSlotMinutes) {
      expect(VenuePolicy.openingHourStep % m, 0, reason: '$m min');
    }
  });
}
