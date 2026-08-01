/// A resolved place from geocoding (Nominatim, etc.).
class GeoPlace {
  const GeoPlace({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  final String displayName;
  final double lat;
  final double lon;

  /// Short label for summary rows (first line of display name).
  String get shortLabel {
    final i = displayName.indexOf(',');
    if (i <= 0) return displayName.trim();
    return displayName.substring(0, i).trim();
  }
}
