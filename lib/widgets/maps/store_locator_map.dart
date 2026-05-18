import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';

class StoreInfo {
  final String id;
  final String name;
  final LatLng position;
  final bool isOpen;

  StoreInfo({
    required this.id,
    required this.name,
    required this.position,
    required this.isOpen,
  });
}

class StoreLocatorMap extends StatefulWidget {
  final List<StoreInfo> stores;
  final void Function(String)? onStoreTapped;
  final LatLng? userPosition;

  const StoreLocatorMap({
    super.key,
    required this.stores,
    this.onStoreTapped,
    this.userPosition,
  });

  @override
  State<StoreLocatorMap> createState() => _StoreLocatorMapState();
}

class _StoreLocatorMapState extends State<StoreLocatorMap> {
  GoogleMapController? _controller;
  BitmapDescriptor? _openStoreIcon;
  BitmapDescriptor? _closedStoreIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
  }

  Future<void> _loadCustomIcons() async {
    // Await BitmapDescriptor.fromAssetImage for real icons
    setState(() {
      _openStoreIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      _closedStoreIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    });
  }

  void _recenterOnUser() {
    if (_controller != null && widget.userPosition != null) {
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(widget.userPosition!, 14));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = widget.stores.map((store) {
      return Marker(
        markerId: MarkerId(store.id),
        position: store.position,
        icon: store.isOpen
            ? (_openStoreIcon ?? BitmapDescriptor.defaultMarker)
            : (_closedStoreIcon ?? BitmapDescriptor.defaultMarker),
        onTap: () {
          if (widget.onStoreTapped != null) {
            widget.onStoreTapped!(store.id);
          }
        },
      );
    }).toSet();

    if (widget.userPosition != null) {
      markers.add(Marker(
        markerId: const MarkerId('user_position'),
        position: widget.userPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    final initialTarget = widget.userPosition ?? 
        (widget.stores.isNotEmpty ? widget.stores.first.position : const LatLng(4.0511, 9.7679));

    return Stack(
      children: [
        FgtGoogleMap(
          initialPosition: CameraPosition(target: initialTarget, zoom: 12),
          onMapCreated: (controller) {
            _controller = controller;
            if (widget.stores.isNotEmpty && widget.userPosition == null) {
              FgtGoogleMap.fitBounds(
                controller: _controller!,
                points: widget.stores.map((s) => s.position).toList(),
              );
            }
          },
          markers: markers,
        ),
        if (widget.userPosition != null)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _recenterOnUser,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
