import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../lanyard_templates/widgets/lanyard_scaled_preview.dart';
import '../../lanyard_templates/widgets/lanyard_template_selector.dart';

class LanyardTemplatePickerCard extends GetView<TemplateController> {
  const LanyardTemplatePickerCard({
    super.key,
    required this.selected,
    required this.templateIndex,
    this.onTap,
  });

  final bool selected;
  final int templateIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Obx(
        () {
          flow.selectedFont.value;
          flow.selectedColor.value;
          final data = controller.lanyardData.value;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: const Color(0xFF8B5CF6), width: 3)
                  : Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(selected ? 9 : 11),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LanyardScaledPreview(
                  maxHeight: 200,
                  child: buildLanyardTemplate(
                    variant: templateIndex,
                    data: data,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
