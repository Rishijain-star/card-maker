import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// OSRM public demo router — returns road-following coordinates (GeoJSON).
///
/// For production, host your own OSRM or use a commercial directions API.
abstract final class OsrmRouteClient {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Driving directions between [a] and [b]; coordinates follow roads where data exists.
  static Future<List<LatLng>> drivingRoute(LatLng a, LatLng b) async {
    final path =
        '/route/v1/driving/${a.longitude},${a.latitude};${b.longitude},${b.latitude}';
    final uri = Uri.https('router.project-osrm.org', path, {
      'overview': 'full',
      'geometries': 'geojson',
    });

    final res = await _dio.getUri<Map<String, dynamic>>(uri);
    final data = res.data;
    if (data == null) return [a, b];

    final routes = data['routes'];
    if (routes is! List || routes.isEmpty) return [a, b];

    final first = routes.first;
    if (first is! Map<String, dynamic>) return [a, b];

    final geometry = first['geometry'];
    if (geometry is! Map<String, dynamic>) return [a, b];

    final coords = geometry['coordinates'];
    if (coords is! List) return [a, b];

    final pts = <LatLng>[];
    for (final c in coords) {
      if (c is List && c.length >= 2) {
        final lon = (c[0] as num).toDouble();
        final lat = (c[1] as num).toDouble();
        pts.add(LatLng(lat, lon));
      }
    }
    if (pts.length < 2) return [a, b];
    return pts;
  }
}
