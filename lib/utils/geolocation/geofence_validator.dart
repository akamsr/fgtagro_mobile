import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'haversine.dart';

bool _rayCastIntersect(LatLng point, LatLng p1, LatLng p2) {
  if (p1.latitude > p2.latitude) {
    final temp = p1;
    p1 = p2;
    p2 = temp;
  }
  if (point.latitude == p1.latitude || point.latitude == p2.latitude) {
    point = LatLng(point.latitude + 0.0000001, point.longitude);
  }
  if (point.latitude > p2.latitude || point.latitude < p1.latitude) {
    return false;
  }
  if (point.longitude > p1.longitude && point.longitude > p2.longitude) {
    return false;
  }
  if (point.longitude < p1.longitude && point.longitude < p2.longitude) {
    return true;
  }
  final dx = p2.longitude - p1.longitude;
  final dy = p2.latitude - p1.latitude;
  final intersectionLongitude = p1.longitude + dx * (point.latitude - p1.latitude) / dy;
  return point.longitude < intersectionLongitude;
}

bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  int intersectCount = 0;
  for (int i = 0; i < polygon.length; i++) {
    final j = (i + 1) % polygon.length;
    if (_rayCastIntersect(point, polygon[i], polygon[j])) {
      intersectCount++;
    }
  }
  return (intersectCount % 2) == 1;
}

bool isPointInCircle({
  required LatLng point,
  required LatLng center,
  required double radiusKm,
}) {
  return haversineDistanceKm(point, center) <= radiusKm;
}
