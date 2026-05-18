import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  late FlutterGooglePlacesSdk _places;

  PlacesService(String apiKey) {
    _places = FlutterGooglePlacesSdk(apiKey);
  }

  Future<List<AutocompletePrediction>> searchPlaces(
    String query, {
    String country = 'CM',
    LatLng? locationBias,
  }) async {
    if (query.length < 3) return [];

    final result = await _places.findAutocompletePredictions(
      query,
      countries: [country],
      locationBias: locationBias != null
          ? LatLngBounds(
              southwest: LatLng(locationBias.latitude - 0.1, locationBias.longitude - 0.1),
              northeast: LatLng(locationBias.latitude + 0.1, locationBias.longitude + 0.1),
            )
          : null,
    );

    return result.predictions;
  }

  Future<LatLng?> getPlaceDetails(String placeId) async {
    final result = await _places.fetchPlace(
      placeId,
      fields: [PlaceField.Location],
    );

    final location = result.place?.latLng;
    if (location != null) {
      return LatLng(location.lat, location.lng);
    }
    return null;
  }
}
