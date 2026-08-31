import 'dart:convert';

class SavedDesign {
  const SavedDesign({
    required this.templatePairId,
    required this.title,
    required this.frontImagePath,
    required this.backImagePath,
    required this.service,
    required this.templateName,
    required this.fontFamily,
    this.fontSizeScale = 1.0,
    required this.savedAtMs,
    required this.instituteName,
    required this.studentName,
    this.lanyardVariant,
    this.lanyardRepeatCount,
    this.lanyardTextOffsetX,
    this.lanyardTextOffsetY,
    this.lanyardLogoTextSpacing,
    this.lanyardTextColorHex,
    this.logoPath,
  });

  final String templatePairId;
  final String title;
  final String frontImagePath;
  final String backImagePath;
  final String service;
  final String templateName;
  final String fontFamily;
  final double fontSizeScale;
  final int savedAtMs;
  final String instituteName;
  final String studentName;
  final int? lanyardVariant;
  final int? lanyardRepeatCount;
  final double? lanyardTextOffsetX;
  final double? lanyardTextOffsetY;
  final double? lanyardLogoTextSpacing;
  final int? lanyardTextColorHex;
  final String? logoPath;

  /// Same as [templatePairId] — one ID links front + back images.
  String get id => templatePairId;

  /// Legacy single-image field (front).
  String get imagePath => frontImagePath;

  String get displayTitle => '$service — $title';

  String get productListTitle {
    final institute = instituteName.trim();
    final student = studentName.trim();
    if (institute.isNotEmpty && student.isNotEmpty) {
      return '$institute · $student';
    }
    return title;
  }

  SavedDesign copyWith({
    String? templatePairId,
    String? title,
    String? frontImagePath,
    String? backImagePath,
    String? service,
    String? templateName,
    String? fontFamily,
    double? fontSizeScale,
    int? savedAtMs,
    String? instituteName,
    String? studentName,
    int? lanyardVariant,
    int? lanyardRepeatCount,
    double? lanyardTextOffsetX,
    double? lanyardTextOffsetY,
    double? lanyardLogoTextSpacing,
    int? lanyardTextColorHex,
    String? logoPath,
  }) {
    return SavedDesign(
      templatePairId: templatePairId ?? this.templatePairId,
      title: title ?? this.title,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      service: service ?? this.service,
      templateName: templateName ?? this.templateName,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      savedAtMs: savedAtMs ?? this.savedAtMs,
      instituteName: instituteName ?? this.instituteName,
      studentName: studentName ?? this.studentName,
      lanyardVariant: lanyardVariant ?? this.lanyardVariant,
      lanyardRepeatCount: lanyardRepeatCount ?? this.lanyardRepeatCount,
      lanyardTextOffsetX: lanyardTextOffsetX ?? this.lanyardTextOffsetX,
      lanyardTextOffsetY: lanyardTextOffsetY ?? this.lanyardTextOffsetY,
      lanyardLogoTextSpacing: lanyardLogoTextSpacing ?? this.lanyardLogoTextSpacing,
      lanyardTextColorHex: lanyardTextColorHex ?? this.lanyardTextColorHex,
      logoPath: logoPath ?? this.logoPath,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'templatePairId': templatePairId,
        'id': templatePairId,
        'title': title,
        'frontImagePath': frontImagePath,
        'backImagePath': backImagePath,
        'imagePath': frontImagePath,
        'service': service,
        'templateName': templateName,
        'fontFamily': fontFamily,
        'fontSizeScale': fontSizeScale,
        'savedAtMs': savedAtMs,
        'instituteName': instituteName,
        'studentName': studentName,
        if (lanyardVariant != null) 'lanyardVariant': lanyardVariant,
        if (lanyardRepeatCount != null) 'lanyardRepeatCount': lanyardRepeatCount,
        if (lanyardTextOffsetX != null) 'lanyardTextOffsetX': lanyardTextOffsetX,
        if (lanyardTextOffsetY != null) 'lanyardTextOffsetY': lanyardTextOffsetY,
        if (lanyardLogoTextSpacing != null) 'lanyardLogoTextSpacing': lanyardLogoTextSpacing,
        if (lanyardTextColorHex != null) 'lanyardTextColorHex': lanyardTextColorHex,
        if (logoPath != null) 'logoPath': logoPath,
      };

  factory SavedDesign.fromJson(Map<String, dynamic> json) {
    final pairId = '${json['templatePairId'] ?? json['id'] ?? ''}';
    final front = '${json['frontImagePath'] ?? json['imagePath'] ?? ''}';
    final title = '${json['title'] ?? 'Untitled'}';
    return SavedDesign(
      templatePairId: pairId,
      title: title,
      frontImagePath: front,
      backImagePath: '${json['backImagePath'] ?? ''}',
      service: '${json['service'] ?? 'ID Card'}',
      templateName: '${json['templateName'] ?? ''}',
      fontFamily: '${json['fontFamily'] ?? 'Poppins'}',
      fontSizeScale: (json['fontSizeScale'] as num?)?.toDouble() ?? 1.0,
      savedAtMs: json['savedAtMs'] as int? ?? 0,
      instituteName: '${json['instituteName'] ?? ''}',
      studentName: '${json['studentName'] ?? title}',
      lanyardVariant: json['lanyardVariant'] as int?,
      lanyardRepeatCount: json['lanyardRepeatCount'] as int?,
      lanyardTextOffsetX: (json['lanyardTextOffsetX'] as num?)?.toDouble(),
      lanyardTextOffsetY: (json['lanyardTextOffsetY'] as num?)?.toDouble(),
      lanyardLogoTextSpacing: (json['lanyardLogoTextSpacing'] as num?)?.toDouble(),
      lanyardTextColorHex: json['lanyardTextColorHex'] as int?,
      logoPath: json['logoPath'] as String?,
    );
  }

  static List<SavedDesign> listFromJsonString(String raw) {
    if (raw.trim().isEmpty) return <SavedDesign>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return <SavedDesign>[];
      return decoded
          .map(
            (dynamic e) => SavedDesign.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return <SavedDesign>[];
    }
  }

  static String listToJsonString(List<SavedDesign> designs) {
    return jsonEncode(designs.map((d) => d.toJson()).toList());
  }
}
