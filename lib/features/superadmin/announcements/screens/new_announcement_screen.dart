import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/domain_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/l10n_labels.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_constraint.dart';
import '../../../../core/widgets/sticky_bottom_bar.dart';
import '../../console/widgets/console_kit.dart';
import '../../shared/providers/platform_providers.dart';
import 'announcements_screen.dart';

/// `/superadmin/settings/announcements/new` — PLATFORM scope: write an
/// announcement for everyone, customers or shop admins.
class NewAnnouncementScreen extends ConsumerStatefulWidget {
  const NewAnnouncementScreen({super.key});

  @override
  ConsumerState<NewAnnouncementScreen> createState() =>
      _NewAnnouncementScreenState();
}

class _NewAnnouncementScreenState extends ConsumerState<NewAnnouncementScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  AnnouncementAudience _audience = AnnouncementAudience.everyone;

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

  static String _audienceText(AppLocalizations l, AnnouncementAudience a) =>
      AnnouncementsScreen.audienceText(l, a);

  bool get _canSend =>
      _title.text.trim().isNotEmpty && _body.text.trim().isNotEmpty;

  Future<void> _send() async {
    final ok = await ref.read(sendAnnouncementControllerProvider.notifier).send(
          title: _title.text,
          body: _body.text,
          audience: _audience,
        );
    if (!mounted) return;
    final l = context.l10n;
    if (ok) {
      showAppSnackBar(context, l.announcementSentToast, tone: SnackTone.success);
      context.pop();
      return;
    }
    final error = ref.read(sendAnnouncementControllerProvider).error;
    final failure =
        error is AppException ? error : UnknownException(cause: error);
    showAppSnackBar(context, failure.messageIn(l), tone: SnackTone.error);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sending = ref.watch(sendAnnouncementControllerProvider).isLoading;
    return Scaffold(
      appBar: ConsoleAppBar(title: l.newAnnouncementTitle),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: l.sendTo(_audienceText(l, _audience)),
          icon: Icons.send_outlined,
          expand: true,
          isLoading: sending,
          onPressed: !_canSend || sending ? null : _send,
        ),
      ),
      body: ConsoleBody(
        width: ContentWidth.form,
        header: ConsoleBand(
          overline: '${l.consolePlatform} · ${l.announcementsTitle}',
          title: l.newAnnouncementTitle,
          width: ContentWidth.form,
        ),
        children: [
          ConsolePanel(
            title: l.audienceLabel,
            padded: true,
            child: SegmentedButton<AnnouncementAudience>(
              segments: [
                for (final a in AnnouncementAudience.values)
                  ButtonSegment(value: a, label: Text(_audienceText(l, a))),
              ],
              selected: {_audience},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _audience = s.first),
            ),
          ),
          consoleGap,
          ConsolePanel(
            title: l.messageLabel,
            padded: true,
            child: Column(
              children: [
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
          ),
        ],
      ),
    );
  }
}
