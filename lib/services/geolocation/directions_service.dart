import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;

class DirectionsResult {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final int durationMinutes;

  DirectionsResult({
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
  });
}

class MultiStopRouteResult {
  final List<LatLng> polylinePoints;
  final List<int> optimizedOrder;

  MultiStopRouteResult({
    required this.polylinePoints,
    required this.optimizedOrder,
  });
}

class DirectionsService {
  late directions.GoogleMapsDirections _directions;

  DirectionsService(String apiKey) {
    _directions = directions.GoogleMapsDirections(apiKey: apiKey);
  }

  Future<DirectionsResult?> getRoute({
    required LatLng origin,
    required LatLng destination,
    directions.TravelMode mode = directions.TravelMode.driving,
  }) async {
    final response = await _directions.directionsWithLocation(
      directions.Location(lat: origin.latitude, lng: origin.longitude),
      directions.Location(lat: destination.latitude, lng: destination.longitude),
      travelMode: mode,
    );

    if (response.isOkay && response.routes.isNotEmpty) {
      final route = response.routes.first;
      final leg = route.legs.first;
      final points = _decodePolyline(route.overviewPolyline.points);
      
      return DirectionsResult(
        polylinePoints: points,
        distanceKm: leg.distance.value / 1000.0,
        durationMinutes: (leg.duration.value / 60).round(),
      );
    }
    return null;
  }

  Future<MultiStopRouteResult?> getOptimizedRoute({
    required LatLng origin,
    required List<LatLng> waypoints,
    required LatLng destination,
    bool optimizeWaypoints = true,
  }) async {
    final wp = waypoints.map((w) => directions.Waypoint.fromLocation(directions.Location(lat: w.latitude, lng: w.longitude))).toList();
    
    final response = await _directions.directionsWithLocation(
      directions.Location(lat: origin.latitude, lng: origin.longitude),
      directions.Location(lat: destination.latitude, lng: destination.longitude),
      waypoints: wp,
    );

    if (response.isOkay && response.routes.isNotEmpty) {
      final route = response.routes.first;
      final points = _decodePolyline(route.overviewPolyline.points);
      
      return MultiStopRouteResult(
        polylinePoints: points,
        optimizedOrder: route.waypointOrder.map((e) => e.toInt()).toList(),
      );
    }
    return null;
  }

  bool isOffRoute({
    required LatLng currentPosition,
    required List<LatLng> routePolyline,
    double thresholdMeters = 500,
  }) {
    // simplified implementation
    return false;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return polyline;
  }
}
