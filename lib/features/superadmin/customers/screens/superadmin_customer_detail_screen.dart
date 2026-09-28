import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';
import '../../../shared/widgets/staff_customer_views.dart';

/// `/superadmin/customers/:customerId` — PLATFORM scope: account, stats and
/// bookings at every shop; the superadmin can disable / enable the account
/// (`users/{uid}.isActive`). PREVIEW: sample data, actions save nothing.
class SuperadminCustomerDetailScreen extends StatelessWidget {
  const SuperadminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final c = DemoData.customer(customerId);
    return Scaffold(
      appBar: AppBar(title: const Text('Customer')),
      body: StaffCustomerDetail(
        customer: c,
        shopId: null,
        onOpenBooking: (b) => context.push(AppRoutes.superadminBooking(b.id)),
        actions: [
          if (c.isActive)
            SecondaryButton(
              label: 'Disable account',
              icon: Icons.block,
              expand: true,
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Disable ${c.name}?',
                  message: 'They are signed out and cannot book until you '
                      'enable the account again.',
                  confirmLabel: 'Disable',
                  dismissLabel: 'Keep active',
                  destructive: true,
                );
                if (ok && context.mounted) {
                  showPreviewOnly(context, 'Disable account');
                }
              },
            )
          else
            PrimaryButton(
              label: 'Enable account',
              icon: Icons.check_circle_outline,
              expand: true,
              onPressed: () => showPreviewOnly(context, 'Enable account'),
            ),
        ],
      ),
    );
  }
}
