import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../data/models/saved_design.dart';
import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';

class MyDesignsView extends GetView<CreateFlowController> {
  const MyDesignsView({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    String id,
    String title,
  ) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove saved card?'),
        content: Text('Delete "$title" from Saved Cards?'),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back<bool>(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      await controller.deleteSavedDesign(id);
    }
  }

  void _openCardViewer(BuildContext context, SavedDesign design) {
    SavedCardViewerDialog.show(
      context,
      design: design,
      onDelete: () => _confirmDelete(context, design.id, design.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Saved Cards', style: AppTextStyles.heading(context, size: 28)),
            const SizedBox(height: AppSpacing.xs),
            Obx(
              () => Text(
                '${controller.lifetimeSaveCount.value} / ${controller.saveLimit} lifetime saves used · '
                '${controller.savedDesigns.length} in library',
                style: AppTextStyles.body(context, size: 13).copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Obx(
                () {
                  if (controller.savedDesigns.isEmpty) {
                    return const AppErrorWidget(
                      message:
                          'No saved cards yet. Create a design and tap Save Design.',
                    );
                  }
                  return ListView.separated(
                    itemCount: controller.savedDesigns.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final design = controller.savedDesigns[index];
                      final hasFront = design.frontImagePath.isNotEmpty &&
                          File(design.frontImagePath).existsSync();
                      final hasBack = design.backImagePath.isNotEmpty &&
                          File(design.backImagePath).existsSync();
                      return AppCard(
                        child: InkWell(
                          onTap: () => _openCardViewer(context, design),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _DesignThumb(
                                        path: design.frontImagePath,
                                        hasFile: hasFront,
                                        label: 'F',
                                      ),
                                      if (hasBack ||
                                          design.backImagePath.isNotEmpty) ...[
                                        const SizedBox(width: 4),
                                        _DesignThumb(
                                          path: design.backImagePath,
                                          hasFile: hasBack,
                                          label: 'B',
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        design.instituteName.isNotEmpty
                                            ? '${design.instituteName} · ${design.studentName}'
                                            : design.displayTitle,
                                        style: AppTextStyles.heading(
                                          context,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'ID: ${design.templatePairId}',
                                        style: AppTextStyles.body(
                                          context,
                                          size: 11,
                                        ).copyWith(
                                          color: const Color(0xFF94A3B8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${design.templateName} · ${design.fontFamily}',
                                        style: AppTextStyles.body(
                                          context,
                                          size: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _openCardViewer(context, design),
                                      icon: const Icon(
                                        Icons.visibility_rounded,
                                        color: Color(0xFF1E88E5),
                                      ),
                                      tooltip: 'View Card',
                                    ),
                                    IconButton(
                                      onPressed: () => _confirmDelete(
                                        context,
                                        design.id,
                                        design.title,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFDC2626),
                                      ),
                                      tooltip: 'Remove',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Obx(
              () {
                if (!controller.showPremiumOption) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: GradientButton(
                    label: 'Premium Subscription',
                    onPressed: () =>
                        Get.toNamed<void>(Routes.PREMIUM_SUBSCRIBE),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SavedCardViewerDialog extends StatefulWidget {
  const SavedCardViewerDialog({
    super.key,
    required this.design,
    required this.onDelete,
  });

  final SavedDesign design;
  final VoidCallback onDelete;

  static void show(
    BuildContext context, {
    required SavedDesign design,
    required VoidCallback onDelete,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SavedCardViewerDialog(
        design: design,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<SavedCardViewerDialog> createState() => _SavedCardViewerDialogState();
}

class _SavedCardViewerDialogState extends State<SavedCardViewerDialog> {
  int _selectedSide = 0; // 0 = Front, 1 = Back

  @override
  Widget build(BuildContext context) {
    final design = widget.design;
    final hasFront = design.frontImagePath.isNotEmpty &&
        File(design.frontImagePath).existsSync();
    final hasBack = design.backImagePath.isNotEmpty &&
        File(design.backImagePath).existsSync();

    final currentPath = _selectedSide == 0
        ? (hasFront ? design.frontImagePath : design.backImagePath)
        : (hasBack ? design.backImagePath : design.frontImagePath);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design.instituteName.isNotEmpty
                            ? '${design.instituteName} · ${design.studentName}'
                            : design.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${design.templateName} · ${design.fontFamily}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasFront && hasBack) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Front Side'),
                    selected: _selectedSide == 0,
                    selectedColor: const Color(0xFF1E88E5),
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: _selectedSide == 0
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _selectedSide = 0),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Back Side'),
                    selected: _selectedSide == 1,
                    selectedColor: const Color(0xFF1E88E5),
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: _selectedSide == 1
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _selectedSide = 1),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 380),
                color: const Color(0xFF1E293B),
                child: currentPath.isNotEmpty && File(currentPath).existsSync()
                    ? InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.8,
                        maxScale: 3.5,
                        child: Image.file(
                          File(currentPath),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image_rounded,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Image file not found',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444), size: 18),
                    label: Text(
                      'Delete Card',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text(
                      'Close',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignThumb extends StatelessWidget {
  const _DesignThumb({
    required this.path,
    required this.hasFile,
    required this.label,
  });

  final String path;
  final bool hasFile;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        hasFile
            ? Image.file(
                File(path),
                width: 52,
                height: 72,
                fit: BoxFit.cover,
              )
            : Container(
                width: 52,
                height: 72,
                color: const Color(0xFFE2E8F0),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFF94A3B8),
                  size: 22,
                ),
              ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
