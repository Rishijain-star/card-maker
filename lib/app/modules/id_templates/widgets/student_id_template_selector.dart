import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
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
import 'company_id_template_selector.dart';
import 'package:get/get.dart';
import '../../create_flow/controllers/create_flow_controller.dart';

/// Picker index matches layout variant (0 → v1, 1 → v2, 2 → v3, …).
int studentTemplateVariantFor(int globalIndex) {
  if (Get.isRegistered<CreateFlowController>()) {
    final flow = Get.find<CreateFlowController>();
    if (globalIndex >= 0 && globalIndex < flow.studentTemplates.length) {
      return (flow.studentTemplates[globalIndex]['variant'] as int?) ?? globalIndex;
    }
  }
  return globalIndex;
}

/// Builds the correct portrait student template without changing template 1 code.
Widget buildStudentPortraitTemplate({
  required int globalIndex,
  required StudentData data,
  required StudentIdCardSide side,
  required String fontFamily,
}) {
  final variant = studentTemplateVariantFor(globalIndex);
  if (variant >= 100 && variant <= 110) {
    return buildCompanyPortraitTemplate(
      globalIndex: variant - 100,
      data: data.toEmployeeData(),
      side: side,
      fontFamily: fontFamily,
      overrideFrontBgAsset: (variant == 104)
          ? 'assets/student_comp_5_front.png'
          : ((variant == 106)
              ? 'assets/student_comp_7_front.png'
              : ((variant == 108) ? 'assets/student_9_front.png' : null)),
    );
  }
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
        frontInstituteTopOverride: 0.055,
      );
    case 4:
      return StudentIdTemplatePortraitV5(
        data: data,
        side: side,
        fontFamily: fontFamily,
        headerTextColor: Colors.white,
        frontInstituteTopOverride: 0.055,
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
        frontInstituteTopOverride: 0.060,
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
        headerTextColor: Colors.black,
      );
    case 10:
      return StudentIdTemplatePortraitV11(
        data: data,
        side: side,
        fontFamily: fontFamily,
        headerTextColor: Colors.black,
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
    case 25:
      return StudentIdTemplatePortrait(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV26,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV26,
        isCenterAligned: true,
        frontInstituteTopOverride: 0.025,
        photoSizeRatio: 0.28,
        contentTopRatio: 0.16,
        contentBottomRatio: 0.14,
      );
    case 26:
      return StudentIdTemplatePortrait(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV27,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV27,
        isCenterAligned: true,
        frontInstituteTopOverride: 0.022,
      );
    case 27:
      return StudentIdTemplatePortraitV3(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV28,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV28,
        frontInstituteTopOverride: 0.050,
        isBackHeaderAtTop: true,
        isBackTermsShiftedDown: true,
      );
    case 28:
      return StudentIdTemplatePortraitV4(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV29,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV29,
        headerTextColor: Colors.white,
        backHeaderTextColor: Colors.white,
        frontInstituteTopOverride: 0.045,
        backTermsTopOverride: 0.35,
      );
    case 29:
      return StudentIdTemplatePortraitV5(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV30,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV30,
        headerTextColor: Colors.white,
      );
    case 30:
      return StudentIdTemplatePortraitV6(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV31,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV31,
      );
    case 31:
      return StudentIdTemplatePortraitV7(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV32,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV32,
        headerTextColor: Colors.white,
        backHeaderTextColor: Colors.white,
      );
    case 32:
      return StudentIdTemplatePortraitV8(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV33,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV33,
        headerTextColor: Colors.white,
      );
    case 33:
      return StudentIdTemplatePortraitV9(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV34,
        backBgAsset: StudentIdTemplateAssets.frontBackgroundV34,
        headerTextColor: Colors.white,
        backHeaderTextColor: Colors.white,
        isBackHeaderAtTop: true,
        isBackTermsAtBottom: true,
        frontInstituteTopOverride: 0.038,
      );
    case 34:
      return StudentIdTemplatePortraitV10(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV35,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV35,
        headerTextColor: Colors.black,
        frontInstituteTopOverride: 0.050,
        backHeaderTextColor: Colors.black,
        isBackHeaderAtBottom: true,
      );
    case 35:
      return StudentIdTemplatePortraitV11(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV36,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV36,
        headerTextColor: Colors.black,
        frontInstituteTopOverride: 0.022,
      );
    case 36:
      return StudentIdTemplatePortrait(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV37,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV37,
        isCenterAligned: true,
        frontInstituteTopOverride: 0.038,
        contentTopRatio: 0.155,
      );
    case 37:
      return StudentIdTemplatePortrait(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV38,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV38,
        isCenterAligned: true,
        frontInstituteTopOverride: 0.038,
        contentTopRatio: 0.155,
      );
    case 38:
      return StudentIdTemplatePortraitV3(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV39,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV39,
        headerTextColor: Colors.white,
        backHeaderTextColor: Colors.white,
        isBackHeaderAtTop: true,
        isBackTermsShiftedDown: true,
        isBackTermsBold: true,
        frontInstituteTopOverride: 0.050,
      );
    case 39:
      return StudentIdTemplatePortraitV4(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: StudentIdTemplateAssets.frontBackgroundV40,
        backBgAsset: StudentIdTemplateAssets.backBackgroundV40,
        headerTextColor: Colors.white,
        backHeaderTextColor: Colors.white,
        frontInstituteTopOverride: 0.050,
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
