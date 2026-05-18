import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationPermissionState {
  notDetermined,
  grantedForeground,
  grantedAlways,
  denied,
  deniedPermanently,
  cityFallback,
}

class LocationService {
  LatLng? _cachedPosition;
  DateTime? _cacheTimestamp;
  static const _cacheDuration = Duration(minutes: 5);

  static const Map<String, LatLng> cityFallbackCoordinates = {
    'Douala': LatLng(4.0511, 9.7679),
    'Yaoundé': LatLng(3.8480, 11.5021),
    'Bafoussam': LatLng(5.4737, 10.4179),
  };

  LocationPermissionState _permissionState = LocationPermissionState.notDetermined;
  LocationPermissionState get permissionState => _permissionState;

  Future<LatLng?> getCurrentPosition({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _cachedPosition != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheDuration) {
      return _cachedPosition;
    }
    return await _fetchFreshPosition();
  }

  Future<LatLng?> _fetchFreshPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _permissionState = LocationPermissionState.denied;
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _permissionState = LocationPermissionState.deniedPermanently;
      return null;
    }

    _permissionState = permission == LocationPermission.always
        ? LocationPermissionState.grantedAlways
        : LocationPermissionState.grantedForeground;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      )
    );
    _cachedPosition = LatLng(position.latitude, position.longitude);
    _cacheTimestamp = DateTime.now();
    return _cachedPosition;
  }

  void setCityFallback(String city) {
    if (cityFallbackCoordinates.containsKey(city)) {
      _cachedPosition = cityFallbackCoordinates[city];
      _cacheTimestamp = DateTime.now().add(const Duration(days: 1)); // Indefinite cache for fallback
      _permissionState = LocationPermissionState.cityFallback;
    }
  }
}
