import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';

@RoutePage()
class RealTimeTrackingScreen extends StatefulWidget {
  const RealTimeTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RealTimeTrackingScreen> createState() => _RealTimeTrackingScreenState();
}

class _RealTimeTrackingScreenState extends State<RealTimeTrackingScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderSystemCubit, OrderSystemState>(
      listener: (context, state) {
        if (state.driverLatitude != null && state.driverLongitude != null) {
          _mapController.move(
            LatLng(state.driverLatitude!, state.driverLongitude!),
            _mapController.camera.zoom,
          );
        }
      },
      builder: (context, state) {
        final driverPos = LatLng(
          state.driverLatitude ?? OrderSystemCubit.startLat,
          state.driverLongitude ?? OrderSystemCubit.startLng,
        );
        final destinationPos = const LatLng(
          OrderSystemCubit.destinationLat,
          OrderSystemCubit.destinationLng,
        );

        return Scaffold(
          body: Stack(
            children: [
              // ==========================================
              // FLUTTER MAP VIEW
              // ==========================================
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: driverPos,
                  initialZoom: 14.5,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [driverPos, destinationPos],
                        color: Colors.blue.shade700,
                        strokeWidth: 4.5,
                        borderColor: Colors.blue.shade900,
                        borderStrokeWidth: 1.5,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      // Destination / Buyer Marker
                      Marker(
                        point: destinationPos,
                        width: 45,
                        height: 45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                            ],
                          ),
                          child: const Icon(Icons.home, color: Colors.white, size: 20),
                        ),
                      ),
                      // Driver Marker
                      Marker(
                        point: driverPos,
                        width: 50,
                        height: 50,
                        child: Transform.rotate(
                          angle: (state.driverHeading ?? 0.0) * (3.1415926535 / 180),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
                              ],
                            ),
                            child: const Icon(Icons.local_shipping, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ==========================================
              // FLOATING BACK BUTTON
              // ==========================================
              Positioned(
                top: 50,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    context.read<OrderSystemCubit>().stopTrackingSimulation();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.secondaryColor),
                  ),
                ),
              ),

              // ==========================================
              // PROXIMITY PUSH NOTIFICATION SIMULATION
              // ==========================================
              if (state.trackingDistanceRemaining != null && state.trackingDistanceRemaining! < 1.0)
                Positioned(
                  top: 110,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.notifications_active, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Le chauffeur est presque arrivé ! Soyez prêt à le recevoir.',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ==========================================
              // BOTTOM ETA DRAWER
              // ==========================================
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: AppColors.primaryColor, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ebanda Samuel',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.8 • Livreur Certifié',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone_outlined, color: AppColors.primaryColor),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(
                            'ETA',
                            state.trackingMinutesRemaining != null
                                ? '${state.trackingMinutesRemaining} mins'
                                : '--',
                            Icons.timer_outlined,
                          ),
                          _buildStatColumn(
                            'DISTANCE',
                            state.trackingDistanceRemaining != null
                                ? '${state.trackingDistanceRemaining!.toStringAsFixed(1)} km'
                                : '--',
                            Icons.directions_outlined,
                          ),
                          _buildStatColumn(
                            'FRAIS',
                            '3 000 FCFA',
                            Icons.payments_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.secondaryColor),
        ),
      ],
    );
  }
}
