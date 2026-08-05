import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import 'student_id_card_side.dart';
import 'student_id_template_portrait.dart';
import 'student_id_template_portrait_v2.dart';
import 'student_id_template_portrait_v3.dart';
import 'student_id_template_portrait_v4.dart';
import 'student_id_template_portrait_v5.dart';
import 'student_id_template_portrait_v6.dart';
import 'student_id_template_portrait_v7.dart';
import 'student_id_template_portrait_v8.dart';
import 'student_id_template_portrait_v9.dart';
import 'student_id_template_portrait_v10.dart';
import 'student_id_template_portrait_v11.dart';
import 'student_id_template_portrait_v13.dart';
import 'student_id_template_portrait_v14.dart';
import 'student_id_template_landscape_v15.dart';
import 'student_id_template_landscape_v16.dart';
import 'student_id_template_portrait_v17.dart';

/// Picker index matches layout variant (0 → v1, 1 → v2, 2 → v3, …).
int studentTemplateVariantFor(int globalIndex) => globalIndex;

/// Builds the correct portrait student template without changing template 1 code.
Widget buildStudentPortraitTemplate({
  required int globalIndex,
  required StudentData data,
  required StudentIdCardSide side,
  required String fontFamily,
}) {
  final variant = studentTemplateVariantFor(globalIndex);
  switch (variant) {
    case 1:
      return StudentIdTemplatePortraitV2(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 2:
      return StudentIdTemplatePortraitV3(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 3:
      return StudentIdTemplatePortraitV4(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 4:
      return StudentIdTemplatePortraitV5(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 5:
      return StudentIdTemplatePortraitV6(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 6:
      return StudentIdTemplatePortraitV7(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 7:
      return StudentIdTemplatePortraitV8(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 8:
      return StudentIdTemplatePortraitV9(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 9:
      return StudentIdTemplatePortraitV10(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 10:
      return StudentIdTemplatePortraitV11(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 11:
      return StudentIdTemplatePortraitV13(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 12:
      return StudentIdTemplatePortraitV14(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 13:
      return StudentIdTemplateLandscapeV15(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 14:
      return StudentIdTemplateLandscapeV16(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 15:
      return StudentIdTemplatePortraitV17(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    default:
      break;
  }
  return StudentIdTemplatePortrait(
    data: data,
    side: side,
    fontFamily: fontFamily,
  );
}
