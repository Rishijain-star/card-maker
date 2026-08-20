import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../lanyard_templates/widgets/custom_lanyard_creator_sheet.dart';
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

    final isCustomCard = templateIndex == 0;
    final variant = flow.lanyardVariantForIndex(templateIndex);

    return GestureDetector(
      onTap: () {
        if (isCustomCard) {
          flow.selectedTemplate.value = 0;
          flow.isCustomLanyard.value = true;
          CustomLanyardCreatorSheet.show(context);
        } else {
          flow.isCustomLanyard.value = false;
          onTap?.call();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Obx(
        () {
          flow.selectedFont.value;
          flow.selectedColor.value;
          flow.lanyardCustomRibbonColorHex.value;
          flow.lanyardCustomTextColorHex.value;
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
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    child: LanyardScaledPreview(
                      maxWidth: MediaQuery.sizeOf(context).width - 32,
                      child: buildLanyardTemplate(
                        variant: variant,
                        data: data,
                      ),
                    ),
                  ),
                  if (isCustomCard)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Tap to Customize',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
