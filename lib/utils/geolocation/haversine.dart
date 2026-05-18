import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double _toRadians(double degree) {
  return degree * pi / 180;
}

double haversineDistanceKm(LatLng point1, LatLng point2) {
  const earthRadiusKm = 6371.0;
  final dLat = _toRadians(point2.latitude - point1.latitude);
  final dLon = _toRadians(point2.longitude - point1.longitude);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(point1.latitude)) *
          cos(_toRadians(point2.latitude)) *
          sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusKm * c;
}

String formatDistance(double km) {
  if (km < 1) return '${(km * 1000).round()} m';
  if (km < 10) return '${km.toStringAsFixed(1)} km';
  return '${km.round()} km';
}
