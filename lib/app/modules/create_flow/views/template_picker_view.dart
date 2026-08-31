import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../core/widgets/shimmer_skeleton_loader.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../id_templates/widgets/id_card_scaled_preview.dart';
import '../controllers/create_flow_controller.dart';
import '../../lanyard_templates/widgets/custom_lanyard_creator_sheet.dart';
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
            if (controller.isLanyardService)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        controller.selectedTemplate.value = 0;
                        controller.isCustomLanyard.value = true;
                        CustomLanyardCreatorSheet.show(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Text('🎨', style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create Your Own Lanyard',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Custom ribbon color, text & logo',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
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
                        separatorBuilder: (context, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final isEmp = flow.isEmployeeService;
                          final selected = isEmp ? flow.employeeSelectedTemplate.value == index : flow.selectedTemplate.value == index;
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
                    controller.isEmployeeService ? controller.employeeSelectedTemplate.value : controller.selectedTemplate.value,
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
