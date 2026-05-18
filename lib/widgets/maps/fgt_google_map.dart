import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/geolocation/map_theme.dart';

class FgtGoogleMap extends StatefulWidget {
  final CameraPosition initialPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Polygon> polygons;
  final Set<Circle> circles;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool tiltGesturesEnabled;
  final void Function(GoogleMapController)? onMapCreated;
  final void Function(LatLng)? onTap;
  final void Function(LatLng)? onLongPress;
  final void Function()? onCameraIdle;
  final void Function(CameraPosition)? onCameraMove;
  final double? height;
  final EdgeInsets padding;

  const FgtGoogleMap({
    super.key,
    required this.initialPosition,
    this.markers = const <Marker>{},
    this.polylines = const <Polyline>{},
    this.polygons = const <Polygon>{},
    this.circles = const <Circle>{},
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.zoomControlsEnabled = false,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.rotateGesturesEnabled = false,
    this.tiltGesturesEnabled = false,
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
    this.onCameraIdle,
    this.onCameraMove,
    this.height,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<FgtGoogleMap> createState() => _FgtGoogleMapState();

  static void fitBounds({
    required GoogleMapController controller,
    required List<LatLng> points,
    double paddingPx = 80,
  }) {
    if (points.isEmpty) return;
    double? minLat, maxLat, minLng, maxLng;
    for (final point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, paddingPx));
  }
}

class _FgtGoogleMapState extends State<FgtGoogleMap> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller!.setMapStyle(fgtMapStyle);
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget map = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: widget.initialPosition,
      markers: widget.markers,
      polylines: widget.polylines,
      polygons: widget.polygons,
      circles: widget.circles,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      compassEnabled: false,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      trafficEnabled: false,
      mapType: MapType.normal,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onCameraIdle: widget.onCameraIdle,
      onCameraMove: widget.onCameraMove,
      padding: widget.padding,
    );

    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: map,
      );
    }
    return map;
  }
}
