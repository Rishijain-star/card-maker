import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../widgets/lanyard_scaled_preview.dart';
import '../widgets/lanyard_template_selector.dart';

class LanyardLivePreview extends GetView<TemplateController> {
  const LanyardLivePreview({
    super.key,
    required this.templateIndex,
    this.repaintBoundaryKey,
  });

  final int templateIndex;
  final GlobalKey? repaintBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();

    return Obx(
      () {
        flow.selectedFont.value;
        flow.selectedColor.value;
        final data = controller.lanyardData.value;

        return RepaintBoundary(
          key: repaintBoundaryKey,
          child: LanyardScaledPreview(
            maxWidth: MediaQuery.sizeOf(context).width - 16,
            child: buildLanyardTemplate(
              variant: templateIndex,
              data: data,
            ),
          ),
        );
      },
    );
  }
}
