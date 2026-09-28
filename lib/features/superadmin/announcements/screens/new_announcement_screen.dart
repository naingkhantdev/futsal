import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../../../data/demo/demo_data.dart';
import '../../../shared/widgets/preview_body.dart';

/// `/superadmin/settings/announcements/new` — PLATFORM scope: write an
/// announcement for everyone, customers or shop admins.
/// PREVIEW: "Send" writes nothing.
class NewAnnouncementScreen extends StatefulWidget {
  const NewAnnouncementScreen({super.key});

  @override
  State<NewAnnouncementScreen> createState() => _NewAnnouncementScreenState();
}

class _NewAnnouncementScreenState extends State<NewAnnouncementScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  DemoAudience _audience = DemoAudience.everyone;

  @override
  void initState() {
    super.initState();
    // Rebuild so "Send" enables once both fields have text.
    _title.addListener(() => setState(() {}));
    _body.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  static String _audienceText(AppLocalizations l, DemoAudience a) =>
      switch (a) {
        DemoAudience.everyone => l.audienceEveryone,
        DemoAudience.customers => l.audienceCustomers,
        DemoAudience.shopAdmins => l.audienceShopAdmins,
      };

  bool get _canSend =>
      _title.text.trim().isNotEmpty && _body.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.newAnnouncementTitle)),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: l.sendTo(_audienceText(l, _audience)),
          icon: Icons.send_outlined,
          expand: true,
          onPressed: !_canSend
              ? null
              : () {
                  showPreviewOnly(context, l.sendAnnouncementAction);
                  context.pop();
                },
        ),
      ),
      body: PreviewBody(
        width: ContentWidth.form,
        children: [
          Text(l.audienceLabel, style: context.textStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<DemoAudience>(
            segments: [
              for (final a in DemoAudience.values)
                ButtonSegment(value: a, label: Text(_audienceText(l, a))),
            ],
            selected: {_audience},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _audience = s.first),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _title,
            maxLength: 60,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.titleLabel),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _body,
            maxLength: 300,
            minLines: 4,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.messageLabel,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
