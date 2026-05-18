import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';
import '../../utils/geolocation/geofence_validator.dart';

class RentalTrackingMap extends StatefulWidget {
  final LatLng equipmentPosition;
  final double equipmentHeading;
  final List<LatLng>? geofencePolygon;
  final LatLng? geofenceCenter;
  final double? geofenceRadiusKm;
  final List<LatLng> historyTrail;

  const RentalTrackingMap({
    super.key,
    required this.equipmentPosition,
    this.equipmentHeading = 0.0,
    this.geofencePolygon,
    this.geofenceCenter,
    this.geofenceRadiusKm,
    this.historyTrail = const [],
  });

  @override
  State<RentalTrackingMap> createState() => _RentalTrackingMapState();
}

class _RentalTrackingMapState extends State<RentalTrackingMap> {
  GoogleMapController? _controller;
  bool _isInsideGeofence = true;
  BitmapDescriptor? _tractorIconRed;
  BitmapDescriptor? _tractorIconGreen;

  @override
  void initState() {
    super.initState();
    _checkGeofence(widget.equipmentPosition);
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    // In real app, load from assets
    setState(() {
      _tractorIconRed = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      _tractorIconGreen = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    });
  }

  @override
  void didUpdateWidget(RentalTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.equipmentPosition != widget.equipmentPosition) {
      _checkGeofence(widget.equipmentPosition);
    }
  }

  void _checkGeofence(LatLng position) {
    bool isInside = true;
    if (widget.geofencePolygon != null && widget.geofencePolygon!.isNotEmpty) {
      isInside = isPointInPolygon(position, widget.geofencePolygon!);
    } else if (widget.geofenceRadiusKm != null && widget.geofenceCenter != null) {
      isInside = isPointInCircle(
        point: position,
        center: widget.geofenceCenter!,
        radiusKm: widget.geofenceRadiusKm!,
      );
    }
    setState(() {
      _isInsideGeofence = isInside;
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Polygon> polygons = {};
    if (widget.geofencePolygon != null && widget.geofencePolygon!.isNotEmpty) {
      polygons.add(Polygon(
        polygonId: const PolygonId('geofence'),
        points: widget.geofencePolygon!,
        fillColor: _isInsideGeofence
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        strokeColor: _isInsideGeofence ? Colors.green : Colors.red,
        strokeWidth: 2,
      ));
    }

    Set<Circle> circles = {};
    if (widget.geofenceRadiusKm != null && widget.geofenceCenter != null) {
      circles.add(Circle(
        circleId: const CircleId('geofence'),
        center: widget.geofenceCenter!,
        radius: widget.geofenceRadiusKm! * 1000,
        fillColor: _isInsideGeofence
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        strokeColor: _isInsideGeofence ? Colors.green : Colors.red,
        strokeWidth: 2,
      ));
    }

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('equipment'),
        position: widget.equipmentPosition,
        rotation: widget.equipmentHeading,
        flat: true,
        icon: _isInsideGeofence
            ? (_tractorIconGreen ?? BitmapDescriptor.defaultMarker)
            : (_tractorIconRed ?? BitmapDescriptor.defaultMarker),
      )
    };

    Set<Polyline> polylines = {};
    if (widget.historyTrail.isNotEmpty) {
      polylines.add(Polyline(
        polylineId: const PolylineId('history'),
        points: widget.historyTrail,
        color: Colors.blue.withOpacity(0.6),
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ));
    }

    return Column(
      children: [
        if (!_isInsideGeofence)
          Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            child: const Text(
              '⚠ Equipment is outside the authorized area',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: FgtGoogleMap(
            initialPosition: CameraPosition(target: widget.equipmentPosition, zoom: 15),
            onMapCreated: (controller) => _controller = controller,
            markers: markers,
            polygons: polygons,
            circles: circles,
            polylines: polylines,
          ),
        ),
      ],
    );
  }
}
