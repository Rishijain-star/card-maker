import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../design_system/id_card_theme.dart';
import 'id_card_scaled_preview.dart';
import 'student_id_card_side.dart';
import 'student_id_template_selector.dart';

/// Scales portrait student card. Use [RepaintBoundary] key for export.
class StudentIdCardView extends StatelessWidget {
  const StudentIdCardView({
    super.key,
    required this.data,
    required this.theme,
    this.templateIndex = 1,
    this.showBack = true,
    this.layout = StudentIdCardLayout.single,
    this.side = StudentIdCardSide.front,
    this.repaintBoundaryKey,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final IdCardTheme theme;
  final int templateIndex;
  final String fontFamily;
  final bool showBack;
  final StudentIdCardLayout layout;
  final StudentIdCardSide side;
  final GlobalKey? repaintBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final card = _buildCard();
    if (repaintBoundaryKey != null) {
      return RepaintBoundary(key: repaintBoundaryKey, child: card);
    }
    return card;
  }

  Widget _buildCard() {
    final face = layout == StudentIdCardLayout.pickerFront
        ? StudentIdCardSide.front
        : side;

    return IdCardScaledPreview.portraitCard(
      child: buildStudentPortraitTemplate(
        globalIndex: templateIndex,
        data: data,
        side: face,
        fontFamily: fontFamily,
      ),
    );
  }
}

enum StudentIdCardLayout {
  single,
  frontAndBack,
  thumbnail,
  pickerFront,
  editor,
}

bool isStudentIdTemplateEngine(int globalIndex) => globalIndex >= 0;
