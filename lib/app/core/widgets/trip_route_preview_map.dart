import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../const/app_colors.dart';

/// Raster map preview (Carto Voyager tiles) with a Google-style blue route polyline.
/// No Google Maps API key required; tuned to feel closer to Google Maps defaults.
class TripRoutePreviewMap extends StatelessWidget {
  const TripRoutePreviewMap({
    super.key,
    this.height = 200,
    this.originLabel = 'A',
    this.destinationLabel = 'B',
  });

  final double height;
  final String originLabel;
  final String destinationLabel;

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
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'dev.flutter.tripmates',
              retinaMode: RetinaMode.isHighDensity(context),
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _route,
                  color: const Color(0xFF4285F4),
                  strokeWidth: 5,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _a,
                  width: 36,
                  height: 36,
                  child: _Pin(label: originLabel, filled: true),
                ),
                Marker(
                  point: _b,
                  width: 36,
                  height: 36,
                  child: _Pin(label: destinationLabel, filled: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? TripMatesColors.mapBlue : TripMatesColors.mapGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}
