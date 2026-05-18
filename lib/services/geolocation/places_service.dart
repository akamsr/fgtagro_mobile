import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as places;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  late places.FlutterGooglePlacesSdk _places;

  PlacesService(String apiKey) {
    _places = places.FlutterGooglePlacesSdk(apiKey);
  }

  Future<List<places.AutocompletePrediction>> searchPlaces(
    String query, {
    String country = 'CM',
    LatLng? locationBias,
  }) async {
    if (query.length < 3) return [];

    final result = await _places.findAutocompletePredictions(
      query,
      countries: [country],
      locationBias: locationBias != null
          ? places.LatLngBounds(
              southwest: places.LatLng(
                lat: locationBias.latitude - 0.1,
                lng: locationBias.longitude - 0.1,
              ),
              northeast: places.LatLng(
                lat: locationBias.latitude + 0.1,
                lng: locationBias.longitude + 0.1,
              ),
            )
          : null,
    );

    return result.predictions;
  }

  Future<LatLng?> getPlaceDetails(String placeId) async {
    final result = await _places.fetchPlace(
      placeId,
      fields: [places.PlaceField.Location],
    );

    final location = result.place?.latLng;
    if (location != null) {
      return LatLng(location.lat, location.lng);
    }
    return null;
  }
}
