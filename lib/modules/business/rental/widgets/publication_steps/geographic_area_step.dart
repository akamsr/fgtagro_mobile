import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeographicAreaStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const GeographicAreaStep({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final areaType = data['geoAreaType'] ?? 'RADIUS';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Geographic Area',
          subtitle:
              'Define the allowed operating area for your equipment. This helps with GPS monitoring and insurance.',
        ),
        _buildTypeOption(
          'Option A — Radius',
          'Operating within a fixed distance from your location.',
          'RADIUS',
          areaType == 'RADIUS',
        ),
        const SizedBox(height: 12),
        _buildTypeOption(
          'Option B — Custom Zone',
          'Draw a specific area on the map where the equipment is allowed.',
          'CUSTOM_ZONE',
          areaType == 'CUSTOM_ZONE',
        ),
        const SizedBox(height: 32),
        if (areaType == 'RADIUS')
          _buildRadiusInput()
        else
          _buildCustomZoneInput(),
        const SizedBox(height: 24),
        _buildMapPreview(),
      ],
    );
  }

  Widget _buildTypeOption(
    String title,
    String subtitle,
    String type,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onUpdate('geoAreaType', type),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTint.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: type,
              groupValue: data['geoAreaType'] ?? 'RADIUS',
              onChanged: (v) => onUpdate('geoAreaType', v),
              activeColor: AppColors.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusInput() {
    return CustomTextField(
      label: 'Maximum distance from my location',
      hint: 'e.g. 50',
      keyboardType: TextInputType.number,
      suffixText: 'km',
      controller:
          TextEditingController(text: data['geoAreaRadius']?.toString() ?? '')
            ..selection = TextSelection.collapsed(
              offset: (data['geoAreaRadius']?.toString() ?? '').length,
            ),
      onChanged: (v) => onUpdate('geoAreaRadius', double.tryParse(v)),
    );
  }

  Widget _buildCustomZoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Draw your zone by tapping on the map below.',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to add points. The last point will connect to the first to form a closed area.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        if ((data['geoAreaPolygon'] as List?)?.isNotEmpty ?? false)
          TextButton.icon(
            onPressed: () => onUpdate('geoAreaPolygon', []),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset Zone'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(3.848, 11.502), // Yaoundé default
            initialZoom: 11,
            onTap: (tapPosition, point) {
              if (data['geoAreaType'] == 'CUSTOM_ZONE') {
                final List<LatLng> polygon = List<LatLng>.from(
                  data['geoAreaPolygon'] ?? [],
                );
                polygon.add(point);
                onUpdate('geoAreaPolygon', polygon);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.fgtagro.mobile',
            ),
            if (data['geoAreaType'] == 'RADIUS' &&
                data['geoAreaRadius'] != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(3.848, 11.502),
                    color: Colors.blue.withOpacity(0.3),
                    borderStrokeWidth: 2,
                    borderColor: Colors.blue,
                    useRadiusInMeter: true,
                    radius: (data['geoAreaRadius'] ?? 0) * 1000,
                  ),
                ],
              ),
            if (data['geoAreaType'] == 'CUSTOM_ZONE' &&
                (data['geoAreaPolygon'] as List?)?.isNotEmpty == true)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: List<LatLng>.from(data['geoAreaPolygon']),
                    color: Colors.green.withOpacity(0.3),
                    // isFilled: true,
                    borderStrokeWidth: 2,
                    borderColor: Colors.green,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
