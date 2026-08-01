import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';

class MyDesignsView extends GetView<CreateFlowController> {
  const MyDesignsView({super.key});

  Future<void> _confirmDelete(BuildContext context, String id, String title) async {
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
                                  if (hasBack || design.backImagePath.isNotEmpty) ...[
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: AppTextStyles.body(context, size: 11).copyWith(
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${design.templateName} · ${design.fontFamily}',
                                    style: AppTextStyles.body(context, size: 13),
                                  ),
                                ],
                              ),
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
                    onPressed: () => Get.toNamed<void>(Routes.PREMIUM_SUBSCRIBE),
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
