import 'package:flutter/foundation.dart';

/// A push notification the app received (console campaign today; booking
/// pushes once a server exists). [route] is an in-app path, validated by
/// the repository (must start with `/`); the router's guards still apply.
@immutable
class PushMessageVO {
  const PushMessageVO({this.title, this.body, this.route});

  final String? title;
  final String? body;
  final String? route;

  bool get hasText => (title ?? '').isNotEmpty || (body ?? '').isNotEmpty;
}
