import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';
import '../../services/geolocation/geocoding_service.dart';
import '../../utils/geolocation/geofence_validator.dart';

class AddressPickerMap extends StatefulWidget {
  final LatLng initialPosition;
  final void Function(LatLng coordinates, String? resolvedAddress) onPositionSelected;
  final List<LatLng>? allowedAreaPolygon;
  final double? allowedAreaRadiusKm;
  final LatLng? allowedAreaCenter;

  const AddressPickerMap({
    super.key,
    required this.initialPosition,
    required this.onPositionSelected,
    this.allowedAreaPolygon,
    this.allowedAreaRadiusKm,
    this.allowedAreaCenter,
  });

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  late LatLng _currentPosition;
  bool _isMoving = false;
  String? _resolvedAddress;
  bool _isInsideAllowedArea = true;
  GoogleMapController? _controller;
  final GeocodingService _geocodingService = GeocodingService();

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
    _checkAllowedArea(_currentPosition);
  }

  void _checkAllowedArea(LatLng position) {
    bool isInside = true;
    if (widget.allowedAreaPolygon != null && widget.allowedAreaPolygon!.isNotEmpty) {
      isInside = isPointInPolygon(position, widget.allowedAreaPolygon!);
    } else if (widget.allowedAreaRadiusKm != null && widget.allowedAreaCenter != null) {
      isInside = isPointInCircle(
        point: position,
        center: widget.allowedAreaCenter!,
        radiusKm: widget.allowedAreaRadiusKm!,
      );
    }
    setState(() {
      _isInsideAllowedArea = isInside;
    });
  }

  void _onCameraMove(CameraPosition position) {
    if (!_isMoving) {
      setState(() {
        _isMoving = true;
      });
    }
    _currentPosition = position.target;
    _checkAllowedArea(_currentPosition);
  }

  void _onCameraIdle() async {
    setState(() {
      _isMoving = false;
    });
    
    final address = await _geocodingService.coordinatesToAddress(_currentPosition);
    setState(() {
      _resolvedAddress = address;
    });
    widget.onPositionSelected(_currentPosition, _resolvedAddress);
  }

  @override
  Widget build(BuildContext context) {
    Set<Polygon> polygons = {};
    if (widget.allowedAreaPolygon != null && widget.allowedAreaPolygon!.isNotEmpty) {
      polygons.add(Polygon(
        polygonId: const PolygonId('allowed_area'),
        points: widget.allowedAreaPolygon!,
        fillColor: _isInsideAllowedArea
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        strokeColor: _isInsideAllowedArea ? Colors.green : Colors.red,
        strokeWidth: 2,
      ));
    }

    Set<Circle> circles = {};
    if (widget.allowedAreaRadiusKm != null && widget.allowedAreaCenter != null) {
      circles.add(Circle(
        circleId: const CircleId('allowed_area'),
        center: widget.allowedAreaCenter!,
        radius: widget.allowedAreaRadiusKm! * 1000, // convert km to meters
        fillColor: _isInsideAllowedArea
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        strokeColor: _isInsideAllowedArea ? Colors.green : Colors.red,
        strokeWidth: 2,
      ));
    }

    return Stack(
      children: [
        FgtGoogleMap(
          initialPosition: CameraPosition(target: widget.initialPosition, zoom: 15),
          onMapCreated: (controller) => _controller = controller,
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
          polygons: polygons,
          circles: circles,
        ),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _isMoving ? -15 : 0, 0),
            child: Icon(
              Icons.location_on,
              size: 40,
              color: _isInsideAllowedArea ? Colors.red : Colors.grey,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black38)],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.my_location,
                  color: _isInsideAllowedArea ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    !_isInsideAllowedArea
                        ? '📍 Outside allowed area'
                        : (_currentPosition == widget.initialPosition)
                            ? '📍 Approximate location — drag map to set'
                            : '📍 Precise location selected',
                    style: TextStyle(
                      color: _isInsideAllowedArea ? Colors.black87 : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
