import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fgt_google_map.dart';

class SellerLocation {
  final String id;
  final LatLng position;

  SellerLocation({required this.id, required this.position});
}

class CatalogSellersMap extends StatefulWidget {
  final List<SellerLocation> sellers;
  final String? selectedSellerId;
  final void Function(String)? onSellerSelected;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const CatalogSellersMap({
    super.key,
    required this.sellers,
    this.selectedSellerId,
    this.onSellerSelected,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  State<CatalogSellersMap> createState() => _CatalogSellersMapState();
}

class _CatalogSellersMapState extends State<CatalogSellersMap> {
  GoogleMapController? _controller;
  bool _userHasPanned = false;

  @override
  void didUpdateWidget(CatalogSellersMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_userHasPanned && widget.sellers != oldWidget.sellers) {
      _fitAllSellers();
    }
  }

  void _fitAllSellers() {
    if (_controller != null && widget.sellers.isNotEmpty) {
      FgtGoogleMap.fitBounds(
        controller: _controller!,
        points: widget.sellers.map((s) => s.position).toList(),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _userHasPanned = true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCollapsed) {
      return GestureDetector(
        onTap: widget.onToggleCollapse,
        child: Container(
          height: 40,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 16),
              SizedBox(width: 8),
              Text('Show Map'),
              Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ),
      );
    }

    final Set<Marker> markers = widget.sellers.map((seller) {
      final isSelected = seller.id == widget.selectedSellerId;
      return Marker(
        markerId: MarkerId(seller.id),
        position: seller.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          if (widget.onSellerSelected != null) {
            widget.onSellerSelected!(seller.id);
          }
        },
      );
    }).toSet();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: FgtGoogleMap(
            initialPosition: const CameraPosition(
              target: LatLng(4.0511, 9.7679),
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _controller = controller;
              _fitAllSellers();
            },
            onCameraMove: _onCameraMove,
            markers: markers,
          ),
        ),
        GestureDetector(
          onTap: widget.onToggleCollapse,
          child: Container(
            height: 30,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Icon(Icons.keyboard_arrow_up, size: 20),
          ),
        ),
      ],
    );
  }
}
