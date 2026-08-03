import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/employee_data.dart';
import '../data/models/student_data.dart';
import '../modules/create_flow/controllers/create_flow_controller.dart';
import '../modules/id_templates/controllers/template_controller.dart';
import '../modules/id_templates/design_system/id_card_dimensions.dart';
import '../modules/id_templates/design_system/id_card_portrait_dimensions.dart';
import '../modules/id_templates/widgets/company_id_template_selector.dart';
import '../modules/id_templates/widgets/student_id_card_side.dart';
import '../modules/id_templates/widgets/student_id_template_selector.dart';
import 'design_export_service.dart';

abstract final class TemplateCaptureService {
  static Future<Uint8List?> captureCurrentSide({
    required StudentIdCardSide side,
    GlobalKey? onScreenFrontKey,
  }) async {
    final flow = Get.find<CreateFlowController>();
    if (!flow.isLanyardService) {
      final bytes = await captureFromFlow(side: side);
      if (bytes != null && bytes.isNotEmpty) return bytes;
    }
    if (side == StudentIdCardSide.front && onScreenFrontKey != null) {
      return DesignExportService.capturePng(onScreenFrontKey);
    }
    return captureFromFlow(side: side);
  }

  static Future<Uint8List?> captureFromFlow({required StudentIdCardSide side}) {
    final flow = Get.find<CreateFlowController>();
    final templateCtrl = Get.find<TemplateController>();

    if (flow.isLanyardService) {
      return Future<Uint8List?>.value(null);
    }

    if (flow.isEmployeeService) {
      return captureEmployeeCard(
        templateIndex: flow.selectedTemplate.value,
        data: templateCtrl.employeeData.value,
        side: side,
        fontFamily: flow.selectedFontFamily,
      );
    }

    return captureStudentCard(
      templateIndex: flow.selectedTemplate.value,
      data: templateCtrl.studentData.value,
      side: side,
      fontFamily: flow.selectedFontFamily,
      landscape: flow.studentTemplateIsLandscape(flow.selectedTemplate.value),
    );
  }

  static Future<Uint8List?> captureStudentCard({
    required int templateIndex,
    required StudentData data,
    required StudentIdCardSide side,
    required String fontFamily,
    bool landscape = false,
  }) {
    final width =
        landscape ? IdCardDimensions.width : IdCardPortraitDimensions.width;
    final height =
        landscape ? IdCardDimensions.height : IdCardPortraitDimensions.height;

    final card = SizedBox(
      width: width,
      height: height,
      child: buildStudentPortraitTemplate(
        globalIndex: templateIndex,
        data: data,
        side: side,
        fontFamily: fontFamily,
      ),
    );

    return DesignExportService.captureWidget(
      card,
      width: width,
      height: height,
      pixelRatio: IdCardDimensions.exportPixelRatio,
    );
  }

  static Future<Uint8List?> captureEmployeeCard({
    required int templateIndex,
    required EmployeeData data,
    required StudentIdCardSide side,
    required String fontFamily,
  }) {
    const width = IdCardPortraitDimensions.width;
    const height = IdCardPortraitDimensions.height;

    final card = SizedBox(
      width: width,
      height: height,
      child: buildCompanyPortraitTemplate(
        globalIndex: templateIndex,
        data: data,
        side: side,
        fontFamily: fontFamily,
      ),
    );

    return DesignExportService.captureWidget(
      card,
      width: width,
      height: height,
      pixelRatio: IdCardDimensions.exportPixelRatio,
    );
  }
}
