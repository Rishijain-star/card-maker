import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import 'company_id_template_selector.dart';
import 'id_card_scaled_preview.dart';
import 'student_id_card_side.dart';

class CompanyIdCardView extends StatelessWidget {
  const CompanyIdCardView({
    super.key,
    required this.data,
    required this.templateIndex,
    this.side = StudentIdCardSide.front,
    this.repaintBoundaryKey,
    this.fontFamily = 'Poppins',
  });

  final EmployeeData data;
  final int templateIndex;
  final StudentIdCardSide side;
  final GlobalKey? repaintBoundaryKey;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    final card = IdCardScaledPreview.portraitCard(
      child: buildCompanyPortraitTemplate(
        globalIndex: templateIndex,
        data: data,
        side: side,
        fontFamily: fontFamily,
      ),
    );
    if (repaintBoundaryKey != null) {
      return RepaintBoundary(key: repaintBoundaryKey, child: card);
    }
    return card;
  }
}
