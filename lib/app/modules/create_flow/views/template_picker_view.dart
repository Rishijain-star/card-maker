import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../core/widgets/shimmer_skeleton_loader.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../id_templates/widgets/id_card_scaled_preview.dart';
import '../controllers/create_flow_controller.dart';
import '../widgets/lanyard_template_picker_card.dart';
import '../widgets/student_template_picker_card.dart';

class TemplatePickerView extends GetView<CreateFlowController> {
  const TemplatePickerView({super.key});

  void _openTemplate(TemplateController templateCtrl, int index) {
    templateCtrl.selectTemplate(index);
    templateCtrl.openTemplateEditor(index);
  }

  @override
  Widget build(BuildContext context) {
    final templateCtrl = Get.find<TemplateController>();
    final rowHeight = templatePickerRowHeight(context);

    return AppScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: Text(
                controller.isLanyardService ? 'Choose Lanyard Style' : 'Choose Template',
                style: AppTextStyles.heading(context, size: 26),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Obx(
                () {
                  if (controller.isTemplatesLoading.value) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TemplateSkeletonPickerCard(
                          height: controller.isLanyardService ? 220 : rowHeight,
                        );
                      },
                    );
                  }
                  return GetBuilder<CreateFlowController>(
                    id: 'template_screen',
                    builder: (flow) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: flow.activeTemplates.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final selected = flow.selectedTemplate.value == index;
                          if (flow.isLanyardService) {
                            return SizedBox(
                              height: 220,
                              child: LanyardTemplatePickerCard(
                                selected: selected,
                                templateIndex: index,
                                onTap: () => _openTemplate(templateCtrl, index),
                              ),
                            );
                          }
                          return SizedBox(
                            height: rowHeight,
                            child: StudentTemplatePickerCard(
                              selected: selected,
                              templateIndex: index,
                              onTap: () => _openTemplate(templateCtrl, index),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GradientButton(
                label: 'Continue',
                onPressed: () {
                  _openTemplate(
                    templateCtrl,
                    controller.selectedTemplate.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
