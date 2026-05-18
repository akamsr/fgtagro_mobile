import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';
import '../../utils/geolocation/coordinate_interpolation.dart';

class DeliveryTrackingMap extends StatefulWidget {
  final LatLng driverPosition;
  final LatLng deliveryAddress;
  final double driverHeading;
  final List<LatLng> routePoints;

  const DeliveryTrackingMap({
    super.key,
    required this.driverPosition,
    required this.deliveryAddress,
    this.driverHeading = 0.0,
    this.routePoints = const [],
  });

  @override
  State<DeliveryTrackingMap> createState() => _DeliveryTrackingMapState();
}

class _DeliveryTrackingMapState extends State<DeliveryTrackingMap> with SingleTickerProviderStateMixin {
  GoogleMapController? _controller;
  late AnimationController _animationController;
  late LatLng _currentDriverPosition;
  bool _userHasPanned = false;
  BitmapDescriptor? _driverIcon;
  BitmapDescriptor? _destinationIcon;

  @override
  void initState() {
    super.initState();
    _currentDriverPosition = widget.driverPosition;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _loadCustomIcons();
  }

  Future<void> _loadCustomIcons() async {
    // In a real implementation, we would await BitmapDescriptor.fromAssetImage
    // For now we use default markers
    setState(() {
      _driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      _destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    });
  }

  @override
  void didUpdateWidget(DeliveryTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverPosition != widget.driverPosition) {
      animateMarkerTo(
        controller: _animationController,
        from: _currentDriverPosition,
        to: widget.driverPosition,
        onUpdate: (pos) {
          setState(() {
            _currentDriverPosition = pos;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    if (!_userHasPanned) {
      _userHasPanned = true;
    }
  }

  void _recenterMap() {
    if (_controller != null) {
      _userHasPanned = false;
      FgtGoogleMap.fitBounds(
        controller: _controller!,
        points: [_currentDriverPosition, widget.deliveryAddress],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: _currentDriverPosition,
        rotation: widget.driverHeading,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: _driverIcon ?? BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: widget.deliveryAddress,
        icon: _destinationIcon ?? BitmapDescriptor.defaultMarker,
      ),
    };

    final Set<Polyline> polylines = {};
    if (widget.routePoints.isNotEmpty) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: widget.routePoints,
        color: const Color(0xFF4285F4), // Google Blue
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ));
    }

    return Stack(
      children: [
        FgtGoogleMap(
          initialPosition: CameraPosition(
            target: widget.driverPosition,
            zoom: 14,
          ),
          onMapCreated: (controller) {
            _controller = controller;
            _recenterMap();
          },
          onCameraMove: _onCameraMove,
          markers: markers,
          polylines: polylines,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _recenterMap,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
