import 'dart:typed_data';

import '../data/models/saved_design.dart';

class PdfExportResult {
  PdfExportResult({
    required this.bytes,
    this.cardCount = 0,
    this.pageCount = 0,
    this.skippedLandscape = 0,
    this.skippedMissing = 0,
  });

  final Uint8List bytes;
  final int cardCount;
  final int pageCount;
  final int skippedLandscape;
  final int skippedMissing;

  bool get isEmpty => bytes.isEmpty;
}

class CardPdfExportService {
  static Future<PdfExportResult> buildPortraitPdf(List<SavedDesign> designs) async {
    return PdfExportResult(bytes: Uint8List(0));
  }

  static Future<String?> saveToAppExportsDir(Uint8List bytes) async {
    return null;
  }

  static Future<bool> sharePdf(Uint8List bytes) async {
    return true;
  }

  static Future<String?> exportSingleCardPdf({
    required Uint8List frontBytes,
    Uint8List? backBytes,
    required String filename,
  }) async {
    return null;
  }

  static Future<String?> exportMultiCardPdf({
    required List<Uint8List> cards,
    required String filename,
  }) async {
    return null;
  }
}
