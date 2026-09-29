import 'package:flutter/material.dart';

/// Google Maps styles that sit with the "Premium" palette: ivory land,
/// white roads, soft slate water, and no business / transit clutter in
/// light; deep navy in dark. Passed to `GoogleMap.style`.
abstract final class AppMapStyle {
  static String of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static const String light = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#f5f3ee"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#5e6472"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#ffffff"}]},
  {"featureType": "poi", "elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi.business", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#e6e8de"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#ffffff"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#ece3cc"}]},
  {"featureType": "road", "elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"featureType": "transit", "stylers": [{"visibility": "off"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#c9d3e3"}]}
]
''';

  static const String dark = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#111a2e"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#a3abbd"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#0a1020"}]},
  {"featureType": "poi", "elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi.business", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#15213a"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#1c2744"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#3a2f17"}]},
  {"featureType": "road", "elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"featureType": "transit", "stylers": [{"visibility": "off"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0a1020"}]}
]
''';
}
