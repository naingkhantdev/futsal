import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
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
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.roleCustomer)),
      body: StaffCustomerDetail(
        customer: c,
        shopId: null,
        onOpenBooking: (b) => context.push(AppRoutes.superadminBooking(b.id)),
        actions: [
          if (c.isActive)
            SecondaryButton(
              label: l.disableAccount,
              icon: Icons.block,
              expand: true,
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: l.disableUserTitle(c.name),
                  message: l.disableUserMessage,
                  confirmLabel: l.disableAction,
                  dismissLabel: l.keepActive,
                  destructive: true,
                );
                if (ok && context.mounted) {
                  showPreviewOnly(context, l.disableAccount);
                }
              },
            )
          else
            PrimaryButton(
              label: l.enableAccount,
              icon: Icons.check_circle_outline,
              expand: true,
              onPressed: () => showPreviewOnly(context, l.enableAccount),
            ),
        ],
      ),
    );
  }
}
