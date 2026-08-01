/// CR80 standard ID card proportions (85.6 × 54 mm) at export-friendly pixel size.
abstract final class IdCardDimensions {
  /// Design canvas width — use with [height] for 1:1 export scaling.
  static const double width = 1012;

  /// Design canvas height.
  static const double height = 638;

  static const double aspectRatio = width / height;

  /// Recommended pixel ratio for PNG / PDF capture.
  static const double exportPixelRatio = 3.0;
}
