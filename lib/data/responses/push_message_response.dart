import 'package:flutter/foundation.dart';

/// Typed DTO for an FCM message. [route] comes from the custom data key
/// `route` (set it in the console campaign's "Additional options").
@immutable
class PushMessageResponse {
  const PushMessageResponse({this.title, this.body, this.route});

  factory PushMessageResponse.fromParts({
    String? title,
    String? body,
    Map<String, dynamic> data = const {},
  }) {
    final route = data[routeKey];
    return PushMessageResponse(
      title: title,
      body: body,
      route: route is String && route.isNotEmpty ? route : null,
    );
  }

  static const String routeKey = 'route';

  final String? title;
  final String? body;
  final String? route;
}
