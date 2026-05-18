import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';

class GeofenceMap extends StatefulWidget {
  final LatLng initialPosition;
  final void Function(List<LatLng> polygon) onPolygonSaved;

  const GeofenceMap({
    super.key,
    required this.initialPosition,
    required this.onPolygonSaved,
  });

  @override
  State<GeofenceMap> createState() => _GeofenceMapState();
}

class _GeofenceMapState extends State<GeofenceMap> {
  GoogleMapController? _controller;
  final List<LatLng> _vertices = [];
  bool _isPolygonClosed = false;

  void _onMapTap(LatLng position) {
    if (_isPolygonClosed) return;
    
    if (_vertices.length >= 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 50 vertices allowed.')),
      );
      return;
    }

    setState(() {
      _vertices.add(position);
    });
  }

  void _closePolygon() {
    if (_vertices.length < 3) return;
    setState(() {
      _isPolygonClosed = true;
    });
    widget.onPolygonSaved(_vertices);
  }

  void _clearRedraw() {
    setState(() {
      _vertices.clear();
      _isPolygonClosed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    for (int i = 0; i < _vertices.length; i++) {
      markers.add(Marker(
        markerId: MarkerId('vertex_$i'),
        position: _vertices[i],
        draggable: _isPolygonClosed,
        onDragEnd: (newPosition) {
          setState(() {
            _vertices[i] = newPosition;
            if (_isPolygonClosed) {
              widget.onPolygonSaved(_vertices);
            }
          });
        },
      ));
    }

    Set<Polygon> polygons = {};
    Set<Polyline> polylines = {};

    if (_isPolygonClosed) {
      polygons.add(Polygon(
        polygonId: const PolygonId('geofence_area'),
        points: _vertices,
        fillColor: Colors.green.withOpacity(0.3),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ));
    } else if (_vertices.length > 1) {
      polylines.add(Polyline(
        polylineId: const PolylineId('geofence_lines'),
        points: _vertices,
        color: Colors.blue,
        width: 2,
      ));
    }

    return Stack(
      children: [
        FgtGoogleMap(
          initialPosition: CameraPosition(target: widget.initialPosition, zoom: 15),
          onMapCreated: (controller) => _controller = controller,
          onTap: _onMapTap,
          markers: markers,
          polygons: polygons,
          polylines: polylines,
        ),
        if (!_isPolygonClosed && _vertices.length >= 3)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _closePolygon,
              child: const Text('Close polygon'),
            ),
          ),
        if (_isPolygonClosed)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _clearRedraw,
              child: const Text('Clear and redraw'),
            ),
          ),
      ],
    );
  }
}
