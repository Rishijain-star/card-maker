import 'package:dio/dio.dart';

import 'geo_place.dart';

/// OpenStreetMap Nominatim search (no API key).
///
/// Respect usage policy: low volume, identifiable User-Agent.
abstract final class NominatimGeocodeService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {
        'User-Agent': 'TripMates/1.0 (ride publish; contact: support@tripmates.invalid)',
        'Accept-Language': 'en',
      },
    ),
  );

  static Future<List<GeoPlace>> search(String query) async {
    final q = query.trim();
    if (q.length < 2) return [];

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': q,
      'format': 'json',
      'limit': '8',
      'addressdetails': '1',
    });

    final res = await _dio.getUri<List<dynamic>>(uri);
    final list = res.data;
    if (list == null) return [];

    final out = <GeoPlace>[];
    for (final raw in list) {
      if (raw is! Map<String, dynamic>) continue;
      final name = raw['display_name'] as String?;
      final latS = raw['lat'] as String?;
      final lonS = raw['lon'] as String?;
      if (name == null || latS == null || lonS == null) continue;
      final lat = double.tryParse(latS);
      final lon = double.tryParse(lonS);
      if (lat == null || lon == null) continue;
      out.add(GeoPlace(displayName: name, lat: lat, lon: lon));
    }
    return out;
  }
}
