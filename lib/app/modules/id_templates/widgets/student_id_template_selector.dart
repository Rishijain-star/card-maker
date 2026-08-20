import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/student_data.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import 'student_id_card_side.dart';
import 'student_id_template_image_only.dart';

/// Helper to get template variant index for a given global picker index.
int studentTemplateVariantFor(int globalIndex) {
  if (Get.isRegistered<CreateFlowController>()) {
    final flow = Get.find<CreateFlowController>();
    if (globalIndex >= 0 && globalIndex < flow.studentTemplates.length) {
      return (flow.studentTemplates[globalIndex]['variant'] as int?) ?? globalIndex;
    }
  }
  return globalIndex;
}

/// Builds the standardized portrait student template (Image + Institute Name overlay).
/// All 40 Student templates use the exact same standardized aspect ratio & container size.
/// Institute Name is rendered identically on every template — zero template-specific logic.
Widget buildStudentPortraitTemplate({
  required int globalIndex,
  required StudentData data,
  required StudentIdCardSide side,
  required String fontFamily,
  bool isPreview = false,
}) {
  final variant = studentTemplateVariantFor(globalIndex);
  
  Color? customHeaderColor;
  Color? customTextColor;
  
  if (Get.isRegistered<CreateFlowController>()) {
    final flow = Get.find<CreateFlowController>();
    
    // Check if we are actively editing this EXACT template in live customize
    if (isPreview && flow.selectedTemplate.value == globalIndex) {
       final headerHex = flow.idCardCustomHeaderColorHex.value;
       if (headerHex != null) customHeaderColor = Color(headerHex);
       
       final textHex = flow.idCardCustomTextColorHex.value;
       if (textHex != null) customTextColor = Color(textHex);
    } else {
       // Just fetch the saved template settings for this index
       final headerHex = flow.getCustomHeaderColorForTemplate(globalIndex);
       if (headerHex != null) customHeaderColor = Color(headerHex);
       
       final textHex = flow.getCustomTextColorForTemplate(globalIndex);
       if (textHex != null) customTextColor = Color(textHex);
    }
  }

  return StudentIdTemplateImageOnly(
    templateIndex: variant,
    side: side,
    instituteName: data.formattedInstituteName,
    fontFamily: fontFamily,
    photoPath: data.photoPath,
    studentName: data.formattedStudentName,
    fatherName: data.formattedFatherName,
    className: data.formattedClassName,
    section: data.section,
    rollNo: data.rollNo,
    mobileNumber: data.mobileNumber,
    bloodGroup: data.bloodGroup,
    address: data.address,
    signaturePath: data.signaturePath,
    signatureBytes: data.signatureBytes,
    term1: data.term1,
    term2: data.term2,
    term3: data.term3,
    validFrom: data.validFrom,
    validTo: data.validTo,
    isPreview: isPreview,
    customHeaderColor: customHeaderColor,
    customTextColor: customTextColor,
  );
}
