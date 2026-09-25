import 'package:flutter/widgets.dart';

/// Root navigator. Pushed (full-screen, nav hidden) routes use it as
/// `parentNavigatorKey`.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
