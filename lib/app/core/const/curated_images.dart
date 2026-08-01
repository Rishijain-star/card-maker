/// Curated Unsplash URLs (ride-share / travel / mobility). Use with `Image.network`.
abstract class CuratedImages {
  CuratedImages._();

  /// Some CDNs omit images without a browser-like User-Agent.
  static const Map<String, String> imageRequestHeaders = {
    'User-Agent': 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
  };

  static const String cabNight =
      'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=900&q=85';
  static const String openRoad =
      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=900&q=85';
  static const String lakeNature =
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=900&q=85';
  static const String forestTrail =
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=900&q=85';
  static const String cityDusk =
      'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?auto=format&fit=crop&w=900&q=85';
  static const String highwayMotion =
      'https://images.unsplash.com/photo-1494783367193-149034c05e8f?auto=format&fit=crop&w=900&q=85';
  static const String carInterior =
      'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&w=900&q=85';
  /// Wide road / travel — reliable on Unsplash CDN.
  static const String welcomeHero =
      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=1200&q=85';
}
