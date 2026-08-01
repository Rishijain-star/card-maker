import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/// Full-featured interactive profile photo cropper screen.
/// Allows zooming, panning, rotating, and cropping square/circular profile pictures.
class ProfileImageCropScreen extends StatefulWidget {
  const ProfileImageCropScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<ProfileImageCropScreen> createState() => _ProfileImageCropScreenState();
}

class _ProfileImageCropScreenState extends State<ProfileImageCropScreen> {
  final TransformationController _transformController =
      TransformationController();

  ui.Image? _loadedImage;
  bool _isLoading = true;
  int _rotationQuarterTurns = 0;
  bool _isSaving = false;

  final GlobalKey _cropAreaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _loadedImage = frame.image;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', 'Failed to load image for cropping');
      }
    }
  }

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
    if (_loadedImage == null || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      const exportSize = 800;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final paint = Paint()
        ..isAntiAlias = true
        ..filterQuality = ui.FilterQuality.high;

      // Draw high-resolution cropped region using viewport transformation
      final matrix = _transformController.value;

      final srcWidth = _loadedImage!.width.toDouble();
      final srcHeight = _loadedImage!.height.toDouble();

      final isRotated90 = _rotationQuarterTurns % 2 != 0;
      final effectiveSrcW = isRotated90 ? srcHeight : srcWidth;
      final effectiveSrcH = isRotated90 ? srcWidth : srcHeight;

      canvas.save();

      // Center and rotate image
      canvas.translate(exportSize / 2, exportSize / 2);
      canvas.rotate(_rotationQuarterTurns * (3.141592653589793 / 2));

      // Apply zoom & translation matrix scaling
      final scaleX = matrix.storage[0];
      final scaleY = matrix.storage[5];
      final scale = (scaleX.abs() + scaleY.abs()) / 2;

      final dx = matrix.storage[12];
      final dy = matrix.storage[13];

      canvas.translate(dx, dy);

      final srcRect = Rect.fromLTWH(0, 0, srcWidth, srcHeight);
      final dstRect = Rect.fromCenter(
        center: Offset.zero,
        width: exportSize * scale * (srcWidth / effectiveSrcW),
        height: exportSize * scale * (srcHeight / effectiveSrcH),
      );

      canvas.drawImageRect(_loadedImage!, srcRect, dstRect, paint);
      canvas.restore();

      final picture = recorder.endRecording();
      final croppedUiImage = await picture.toImage(exportSize, exportSize);
      final byteData = await croppedUiImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to encode cropped image');
      }

      final croppedBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final croppedFile = File(
        '${tempDir.path}/cropped_profile_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await croppedFile.writeAsBytes(croppedBytes);

      if (mounted) {
        Get.back(result: croppedFile.path);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        Get.snackbar('Crop Error', 'Failed to crop image: $e');
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
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Crop Profile Photo',
          style: TextStyle(
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: RotatedBox(
                          quarterTurns: _rotationQuarterTurns,
                          child: InteractiveViewer(
                            transformationController: _transformController,
                            minScale: 0.5,
                            maxScale: 4.0,
                            boundaryMargin: const EdgeInsets.all(300),
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      // Crop Window Mask Overlay
                      IgnorePointer(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cropSize = constraints.maxWidth * 0.85;
                            return Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withValues(alpha: 0.65),
                                    BlendMode.srcOut,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          backgroundBlendMode: BlendMode.dstOut,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          key: _cropAreaKey,
                                          width: cropSize,
                                          height: cropSize,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: cropSize,
                                    height: cropSize,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF2563EB),
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
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
                              _isSaving ? 'Cropping...' : 'Crop & Save',
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
            ),
    );
  }
}
