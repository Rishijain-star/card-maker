import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import 'company_id_template_portrait_v1.dart';
import 'company_id_template_portrait_v2.dart';
import 'company_id_template_portrait_v3.dart';
import 'company_id_template_portrait_v4.dart';
import 'company_id_template_portrait_v5.dart';
import 'company_id_template_portrait_v6.dart';
import 'company_id_template_portrait_v7.dart';
import 'company_id_template_portrait_v8.dart';
import 'company_id_template_portrait_v9.dart';
import 'company_id_template_portrait_v10.dart';
import 'company_id_template_portrait_v11.dart';
import 'student_id_card_side.dart';

int companyTemplateVariantFor(int globalIndex) => globalIndex;

Widget buildCompanyPortraitTemplate({
  required int globalIndex,
  required EmployeeData data,
  required StudentIdCardSide side,
  required String fontFamily,
  String? overrideFrontBgAsset,
}) {
  final variant = companyTemplateVariantFor(globalIndex);
  switch (variant) {
    case 0:
      return CompanyIdTemplatePortraitV1(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 1:
      return CompanyIdTemplatePortraitV2(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 2:
      return CompanyIdTemplatePortraitV3(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 3:
      return CompanyIdTemplatePortraitV4(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 4:
      return CompanyIdTemplatePortraitV5(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: overrideFrontBgAsset,
      );
    case 5:
      return CompanyIdTemplatePortraitV6(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 6:
      return CompanyIdTemplatePortraitV7(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: overrideFrontBgAsset,
      );
    case 7:
      return CompanyIdTemplatePortraitV8(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 8:
      return CompanyIdTemplatePortraitV9(
        data: data,
        side: side,
        fontFamily: fontFamily,
        frontBgAsset: overrideFrontBgAsset,
      );
    case 9:
      return CompanyIdTemplatePortraitV10(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    case 10:
      return CompanyIdTemplatePortraitV11(
        data: data,
        side: side,
        fontFamily: fontFamily,
      );
    default:
      break;
  }
  return CompanyIdTemplatePortraitV1(
    data: data,
    side: side,
    fontFamily: fontFamily,
  );
}

bool isEmployeeIdTemplateEngine(int globalIndex) => globalIndex >= 0;
