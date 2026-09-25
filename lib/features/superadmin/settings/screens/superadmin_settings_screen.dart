import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';
import '../../../auth/widgets/sign_out_button.dart';

/// `/superadmin/settings` - placeholder (PLATFORM settings arrive later).
/// Has a working "Log out" button shared with the customer profile.
class SuperadminSettingsScreen extends StatelessWidget {
  const SuperadminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
        title: 'Settings',
        footer: SignOutButton(),
      );
}
