import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryZoneResult {
  final bool covered;
  final String? nearestCoveredCity;

  DeliveryZoneResult({
    required this.covered,
    this.nearestCoveredCity,
  });
}

class GeofenceService {
  Future<DeliveryZoneResult?> validateAddressCoverage({
    required LatLng address,
  }) async {
    // This is simulated backend check as instructed.
    return DeliveryZoneResult(
      covered: true,
    );
  }
}
