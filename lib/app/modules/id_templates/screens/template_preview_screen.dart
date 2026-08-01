import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../core/widgets/shimmer_skeleton_loader.dart';
import '../../../routes/app_pages.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../controllers/template_controller.dart';
import '../../lanyard_templates/widgets/lanyard_live_preview.dart';
import '../widgets/student_id_card_carousel.dart' show LiveIdCardCarousel;
import '../widgets/template_editor_toolbar.dart';

/// Editor — card uses full screen width (reference layout).
class TemplatePreviewScreen extends GetView<TemplateController> {
  const TemplatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();
    final globalIndex = flow.selectedTemplate.value;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        flow.loadFontSizeScaleForCurrentTemplate();
      },
      child: AppScaffold(
        child: ColoredBox(
          color: const Color(0xFFF8FAFC),
          child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, AppSpacing.lg, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back<void>,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      flow.templateTitleAt(globalIndex),
                      style: AppTextStyles.heading(context, size: 22),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var poppedToMyDesigns = false;
                      Get.until((route) {
                        if (route.settings.name == Routes.MY_DESIGNS) {
                          poppedToMyDesigns = true;
                          return true;
                        }
                        return false;
                      });
                      if (!poppedToMyDesigns) {
                        Get.back<void>();
                      }
                    },
                    icon: const Icon(Icons.close_rounded, size: 26, color: Color(0xFF64748B)),
                    tooltip: 'Close Preview',
                  ),
                ],
              ),
            ),
            Expanded(
              child: flow.isLanyardService
                  ? Obx(
                      () {
                        flow.selectedFont.value;
                        flow.selectedColor.value;
                        return LanyardLivePreview(
                          key: ValueKey<String>(
                            'lanyard-$globalIndex-'
                            '${flow.selectedFont.value}-'
                            '${flow.selectedColor.value}-'
                            '${controller.lanyardData.value.logoPath}',
                          ),
                          templateIndex: globalIndex,
                          repaintBoundaryKey: controller.frontExportKey,
                        );
                      },
                    )
                  : Obx(
                      () {
                        flow.selectedFont.value;
                        return LiveIdCardCarousel(
                          key: ValueKey<String>(
                            '${flow.isEmployeeService}-'
                            '$globalIndex-'
                            '${flow.selectedFont.value}-'
                            '${controller.studentData.value.photoPath}-'
                            '${controller.employeeData.value.photoPath}',
                          ),
                          templateIndex: globalIndex,
                          repaintBoundaryKey: controller.frontExportKey,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 4, AppSpacing.lg, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TemplateEditorToolbar(),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(
                    label: 'Save & Finish',
                    onPressed: () {
                      SaveOptionsBottomSheet.show(
                        context: context,
                        onSaveOnly: () {
                          flow.executeSaveDesignWorkflow(
                            controller.frontExportKey,
                            createNew: false,
                            context: context,
                          );
                        },
                        onSaveAndNew: () {
                          flow.executeSaveDesignWorkflow(
                            controller.frontExportKey,
                            createNew: true,
                            context: context,
                          );
                        },
                        onCancel: () {
                          flow.handleSaveCancel();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    ),
    );
  }
}
