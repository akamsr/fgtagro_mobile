import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart' as distance;

class DistanceMatrixResult {
  final double distanceKm;
  final int durationMinutes;

  DistanceMatrixResult({
    required this.distanceKm,
    required this.durationMinutes,
  });
}

class DistanceService {
  late distance.GoogleDistanceMatrix _distanceMatrix;

  DistanceService(String apiKey) {
    _distanceMatrix = distance.GoogleDistanceMatrix(apiKey: apiKey);
  }

  Future<DistanceMatrixResult?> getRoadDistance({
    required LatLng origin,
    required LatLng destination,
    distance.TravelMode mode = distance.TravelMode.driving,
  }) async {
    final response = await _distanceMatrix.distanceWithLocation(
      [distance.Location(lat: origin.latitude, lng: origin.longitude)],
      [distance.Location(lat: destination.latitude, lng: destination.longitude)],
      travelMode: mode,
    );

    if (response.isOkay && response.rows.isNotEmpty) {
      final element = response.rows.first.elements.first;
      return DistanceMatrixResult(
        distanceKm: element.distance.value / 1000.0,
        durationMinutes: (element.duration.value / 60).round(),
      );
    }
    return null;
  }
}
