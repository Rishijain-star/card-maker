import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/// Full-featured interactive profile photo cropper screen.
/// Bulletproof & crash-free implementation using RepaintBounYdary capture.
class ProfileImageCropScreen extends StatefulWidget {
  const ProfileImageCropScreen({
    super.key,
    required this.imagePath,
    this.isSignature = false,
  });

  final String imagePath;
  final bool isSignature;

  @override
  State<ProfileImageCropScreen> createState() => _ProfileImageCropScreenState();
}

class _ProfileImageCropScreenState extends State<ProfileImageCropScreen> {
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _repaintKey = GlobalKey();

  int _rotationQuarterTurns = 0;
  bool _isSaving = false;

  void _rotateClockwise() {
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
      _transformController.value = Matrix4.identity();
    });
  }

  void _resetTransform() {
    setState(() {
      _rotationQuarterTurns = 0;
      _transformController.value = Matrix4.identity();
    });
  }

  Future<void> _cropAndSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final croppedBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final croppedFile = File(
            '${tempDir.path}/cropped_profile_${DateTime.now().millisecondsSinceEpoch}.png',
          );
          await croppedFile.writeAsBytes(croppedBytes);

          if (mounted) {
            Get.back(result: croppedFile.path);
            return;
          }
        }
      }
      // If boundary was null, fallback to raw path
      Get.back(result: widget.imagePath);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        Get.snackbar('Crop Notice', 'Using original image: $e');
        Get.back(result: widget.imagePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(result: widget.imagePath),
        ),
        title: Text(
          widget.isSignature ? 'Crop Signature' : 'Crop Profile Photo',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.rotate_right_rounded, color: Colors.white),
            tooltip: 'Rotate',
            onPressed: _rotateClockwise,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white),
            tooltip: 'Reset',
            onPressed: _resetTransform,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cropWidth = constraints.maxWidth * 0.85;
          final cropHeight = cropWidth;
          const cropRadius = 16.0;

          return Column(
            children: [
              const SizedBox(height: 12),
              Text(
                widget.isSignature
                    ? 'Drag, zoom, and adjust signature inside the box'
                    : 'Drag, zoom, and adjust photo inside the box',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Container(
                    width: cropWidth,
                    height: cropHeight,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(cropRadius),
                      border: Border.all(
                        color: const Color(0xFF2563EB),
                        width: 3.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cropRadius - 3),
                      child: RepaintBoundary(
                        key: _repaintKey,
                        child: Container(
                          color: Colors.black,
                          child: RotatedBox(
                            quarterTurns: _rotationQuarterTurns,
                            child: InteractiveViewer(
                              transformationController: _transformController,
                              minScale: 0.8,
                              maxScale: 5.0,
                              boundaryMargin: const EdgeInsets.all(200),
                              child: Center(
                                child: Image.file(
                                  File(widget.imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.white54,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                color: const Color(0xFF1E293B),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white38),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Get.back(result: widget.imagePath),
                          child: const Text(
                            'Use Original',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.crop_rounded),
                          label: Text(
                            _isSaving ? 'Saving...' : 'Crop & Save',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _isSaving ? null : _cropAndSave,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
