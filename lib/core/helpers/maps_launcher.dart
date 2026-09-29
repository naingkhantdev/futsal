import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../widgets/app_snackbar.dart';

/// Hands a Google Maps link to the Maps app (or the browser when it isn't
/// installed). Shows a friendly snackbar if nothing can open it.
Future<void> openInMaps(BuildContext context, Uri uri) async {
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    showAppSnackBar(context, context.l10n.mapOpenFailed, tone: SnackTone.error);
  }
}
