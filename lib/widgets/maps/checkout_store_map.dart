import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';

enum StoreStockStatus {
  fullStock,
  partialStock,
  noStock,
}

class CheckoutStore {
  final String id;
  final LatLng position;
  final StoreStockStatus stockStatus;

  CheckoutStore({
    required this.id,
    required this.position,
    required this.stockStatus,
  });
}

class CheckoutStoreMap extends StatefulWidget {
  final List<CheckoutStore> stores;
  final void Function(String)? onStoreTapped;

  const CheckoutStoreMap({
    super.key,
    required this.stores,
    this.onStoreTapped,
  });

  @override
  State<CheckoutStoreMap> createState() => _CheckoutStoreMapState();
}

class _CheckoutStoreMapState extends State<CheckoutStoreMap> {
  GoogleMapController? _controller;
  BitmapDescriptor? _fullStockIcon;
  BitmapDescriptor? _partialStockIcon;

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    setState(() {
      _fullStockIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      _partialStockIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleStores = widget.stores.where((s) => s.stockStatus != StoreStockStatus.noStock).toList();

    Set<Marker> markers = visibleStores.map((store) {
      final isFullStock = store.stockStatus == StoreStockStatus.fullStock;
      return Marker(
        markerId: MarkerId(store.id),
        position: store.position,
        icon: isFullStock
            ? (_fullStockIcon ?? BitmapDescriptor.defaultMarker)
            : (_partialStockIcon ?? BitmapDescriptor.defaultMarker),
        onTap: () {
          if (widget.onStoreTapped != null) {
            widget.onStoreTapped!(store.id);
          }
        },
      );
    }).toSet();

    return FgtGoogleMap(
      initialPosition: CameraPosition(
        target: visibleStores.isNotEmpty ? visibleStores.first.position : const LatLng(4.0511, 9.7679),
        zoom: 12,
      ),
      onMapCreated: (controller) {
        _controller = controller;
        if (visibleStores.isNotEmpty) {
          FgtGoogleMap.fitBounds(
            controller: _controller!,
            points: visibleStores.map((s) => s.position).toList(),
          );
        }
      },
      markers: markers,
    );
  }
}
