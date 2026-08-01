import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../routes/app_pages.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../lanyard_templates/widgets/lanyard_live_preview.dart';
import '../../id_templates/widgets/student_id_card_carousel.dart' show LiveIdCardCarousel;
import '../controllers/create_flow_controller.dart';

class LivePreviewView extends GetView<CreateFlowController> {
  const LivePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final templateCtrl = Get.find<TemplateController>();
    final globalIndex = controller.selectedTemplate.value;

    return AppScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Live Preview', style: AppTextStyles.heading(context, size: 28)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                controller.isLanyardService
                    ? 'Your lanyard design'
                    : 'Swipe sideways for back side',
                style: AppTextStyles.body(context),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Obx(
                  () {
                    controller.selectedFont.value;
                    if (controller.isLanyardService) {
                      controller.selectedColor.value;
                      return LanyardLivePreview(
                        templateIndex: globalIndex,
                        repaintBoundaryKey: templateCtrl.frontExportKey,
                      );
                    }
                    return LiveIdCardCarousel(
                      templateIndex: globalIndex,
                      repaintBoundaryKey: templateCtrl.frontExportKey,
                    );
                  },
                ),
              ),
              Obx(
                () {
                  if (!controller.canSaveMoreDesigns) {
                    return GradientButton(
                      label: 'Premium Subscription',
                      onPressed: () => Get.toNamed<void>(Routes.PREMIUM_SUBSCRIBE),
                    );
                  }
                  return GradientButton(
                    label: 'Save Design',
                    onPressed: () async {
                      final saved = await controller.saveDesignFromPreview(
                        templateCtrl.frontExportKey,
                      );
                      if (!saved) return;
                      Get.until(
                        (route) => route.settings.name == Routes.TEMPLATES,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
