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
      [distance.Location(origin.latitude, origin.longitude)],
      [distance.Location(destination.latitude, destination.longitude)],
      travelMode: mode,
    );

    if (response.isOkay && response.results.isNotEmpty) {
      final element = response.results.first.elements.first;
      if (element.status == 'OK') {
        return DistanceMatrixResult(
          distanceKm: element.distance.value / 1000.0,
          durationMinutes: (element.duration.value / 60).round(),
        );
      }
    }
    return null;
  }
}
