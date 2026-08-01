import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

abstract final class DesignExportService {
  static Future<Uint8List?> capturePng(
    GlobalKey key, {
    double pixelRatio = 3,
  }) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future<String?> saveToAppDir(Uint8List bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final designsDir = Directory('${dir.path}/saved_designs');
    if (!await designsDir.exists()) {
      await designsDir.create(recursive: true);
    }
    final file = File('${designsDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<Uint8List?> captureWidget(
    Widget widget, {
    required double width,
    required double height,
    double pixelRatio = 3,
  }) async {
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.views.first;
    final renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        physicalConstraints: BoxConstraints.tight(Size(width, height)),
        logicalConstraints: BoxConstraints.tight(Size(width, height)),
        devicePixelRatio: pixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: widget,
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future<bool> saveToGallery(Uint8List bytes, {required String name}) async {
    try {
      if (!await Gal.hasAccess(toAlbum: true)) {
        await Gal.requestAccess(toAlbum: true);
      }
      if (!await Gal.hasAccess(toAlbum: true)) {
        return false;
      }
      await Gal.putImageBytes(bytes, name: name);
      return true;
    } catch (_) {
      try {
        await Gal.putImageBytes(bytes, name: name);
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  /// Saves [bytes] to gallery; retries once after re-requesting access.
  static Future<bool> saveToGalleryReliable(
    Uint8List bytes, {
    required String name,
  }) async {
    if (await saveToGallery(bytes, name: name)) return true;
    await Gal.requestAccess(toAlbum: true);
    return saveToGallery(bytes, name: name);
  }
}
