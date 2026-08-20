import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../id_templates/widgets/company_id_template_selector.dart';
import '../../id_templates/widgets/id_card_scaled_preview.dart';
import '../../id_templates/widgets/student_id_card_side.dart';
import '../../id_templates/widgets/student_id_template_selector.dart';
import '../../../data/models/employee_data.dart';
import '../../../data/models/student_data.dart';

/// Front 50% | Back 50% — PNG background + live form data.
class StudentTemplatePickerCard extends GetView<TemplateController> {
  const StudentTemplatePickerCard({
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
          final templateFontFamily = flow.getFontFamilyForTemplate(templateIndex);
          final isEmployee = flow.isEmployeeService;
          final frontOnly =
              !isEmployee && flow.studentTemplateIsFrontOnly(templateIndex);
          final landscape =
              !isEmployee && flow.studentTemplateIsLandscape(templateIndex);
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: const Color(0xFF2563EB), width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(selected ? 9 : 12),
              child: frontOnly
                  ? _Face(
                      fontFamily: templateFontFamily,
                      templateIndex: templateIndex,
                      side: StudentIdCardSide.front,
                      isEmployee: isEmployee,
                      landscape: landscape,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _Face(
                            fontFamily: templateFontFamily,
                            templateIndex: templateIndex,
                            side: StudentIdCardSide.front,
                            isEmployee: isEmployee,
                            landscape: landscape,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _Face(
                            fontFamily: templateFontFamily,
                            templateIndex: templateIndex,
                            side: StudentIdCardSide.back,
                            isEmployee: isEmployee,
                            landscape: landscape,
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

class _Face extends StatelessWidget {
  const _Face({
    required this.fontFamily,
    required this.templateIndex,
    required this.side,
    required this.isEmployee,
    this.landscape = false,
  });

  final String fontFamily;
  final int templateIndex;
  final StudentIdCardSide side;
  final bool isEmployee;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final templateCtrl = Get.find<TemplateController>();

    final card = isEmployee
        ? buildCompanyPortraitTemplate(
            globalIndex: templateIndex,
            data: templateCtrl.employeeData.value,
            side: side,
            fontFamily: fontFamily,
          )
        : buildStudentPortraitTemplate(
            globalIndex: templateIndex,
            data: templateCtrl.studentData.value,
            side: side,
            fontFamily: fontFamily,
          );

    if (landscape && !isEmployee) {
      return IdCardScaledPreview.landscapeCard(child: card);
    }
    return IdCardScaledPreview.portraitCard(child: card);
  }
}
