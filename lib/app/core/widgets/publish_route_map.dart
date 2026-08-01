import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../const/app_colors.dart';

/// Map + road-style polyline for publish flow. Uses Carto Voyager tiles.
class PublishRouteMap extends StatelessWidget {
  const PublishRouteMap({
    super.key,
    required this.routePoints,
    this.origin,
    this.destination,
    this.height = 200,
    this.loading = false,
  });

  final List<LatLng> routePoints;
  final LatLng? origin;
  final LatLng? destination;
  final double height;
  final bool loading;

  static final LatLng _defaultCenter = LatLng(20.5937, 78.9629); // India overview

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];
    if (origin != null) {
      markers.add(
        Marker(
          point: origin!,
          width: 36,
          height: 36,
          child: const _Pin(label: 'A', filled: true),
        ),
      );
    }
    if (destination != null) {
      markers.add(
        Marker(
          point: destination!,
          width: 36,
          height: 36,
          child: const _Pin(label: 'B', filled: false),
        ),
      );
    }

    final hasRoute = routePoints.length >= 2;
    final boundsPoints = <LatLng>[
      ...routePoints,
      ?origin,
      ?destination,
    ];

    final MapOptions mapOptions;
    if (boundsPoints.length == 1) {
      mapOptions = MapOptions(
        initialCenter: boundsPoints.first,
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
        ),
      );
    } else if (boundsPoints.isNotEmpty) {
      final b = LatLngBounds.fromPoints(boundsPoints);
      mapOptions = MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: b,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
        ),
      );
    } else {
      mapOptions = MapOptions(
        initialCenter: _defaultCenter,
        initialZoom: 4.6,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            FlutterMap(
              key: ValueKey<String>('${routePoints.length}_${origin?.latitude}_${destination?.latitude}'),
              options: mapOptions,
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'dev.flutter.tripmates',
                  retinaMode: RetinaMode.isHighDensity(context),
                ),
                if (hasRoute)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: const Color(0xFF4285F4),
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                if (markers.isNotEmpty) MarkerLayer(markers: markers),
              ],
            ),
            if (loading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x33FFFFFF),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                  ),
                ),
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
