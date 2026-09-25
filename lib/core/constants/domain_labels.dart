import 'package:flutter/material.dart';

import 'domain_enums.dart';

/// Display copy + icons for domain enums that aren't statuses (statuses
/// live in `core/theme/status_visuals.dart`).

extension FacilityLabel on Facility {
  String get label => switch (this) {
        Facility.parking => 'Parking',
        Facility.shower => 'Shower',
        Facility.changingRoom => 'Changing room',
        Facility.drinkingWater => 'Drinking water',
        Facility.floodLights => 'Flood lights',
        Facility.seating => 'Seating',
        Facility.restroom => 'Restroom',
        Facility.cafe => 'Cafe',
        Facility.equipmentRental => 'Equipment rental',
      };

  IconData get icon => switch (this) {
        Facility.parking => Icons.local_parking,
        Facility.shower => Icons.shower_outlined,
        Facility.changingRoom => Icons.checkroom,
        Facility.drinkingWater => Icons.water_drop_outlined,
        Facility.floodLights => Icons.light_mode_outlined,
        Facility.seating => Icons.event_seat_outlined,
        Facility.restroom => Icons.wc,
        Facility.cafe => Icons.local_cafe_outlined,
        Facility.equipmentRental => Icons.sports_soccer,
      };
}

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.superadmin => 'Platform admin',
        UserRole.shopAdmin => 'Shop admin',
        UserRole.customer => 'Customer',
      };
}
