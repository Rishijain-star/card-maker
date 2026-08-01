import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../const/app_colors.dart';

/// Live driver marker on the same corridor as [TripRoutePreviewMap].
class LiveTripMap extends StatelessWidget {
  const LiveTripMap({super.key, required this.driver, this.height = 240});

  final Rx<LatLng> driver;
  final double height;

  static final LatLng _a = LatLng(59.3293, 18.0686);
  static final LatLng _b = LatLng(59.4022, 17.9450);

  List<LatLng> get _route => [
        _a,
        LatLng(59.35, 18.02),
        LatLng(59.37, 17.98),
        _b,
      ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(59.36, 18.02),
            initialZoom: 10.2,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.flutter.tripmates',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _route,
                color: TripMatesColors.mapBlue,
                strokeWidth: 5,
              ),
            ],
          ),
            Obx(
              () => MarkerLayer(
                markers: [
                  Marker(
                    point: _a,
                    width: 32,
                    height: 32,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: TripMatesColors.mapBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Marker(
                    point: _b,
                    width: 32,
                    height: 32,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: TripMatesColors.mapGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'B',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Marker(
                    point: driver.value,
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: TripMatesColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: TripMatesColors.green.withValues(alpha: 0.45),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.directions_car, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
