import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../modules/create_flow/controllers/create_flow_controller.dart';

/// Dynamic fields for company / employee ID card templates.
class EmployeeData {
  const EmployeeData({
    this.companyName = '',
    this.logoAsset = '',
    this.employeeName = '',
    this.position = '',
    this.employeeId = '',
    this.joinDate = '',
    this.expireDate = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.bloodGroup = '',
    this.photoPath = '',
    this.signaturePath = '',
    this.signatureBytes,
    this.signatureHasBorder = false,
    this.signatureBorderColor = const Color(0xFF0F172A),
    this.signatureBorderWidth = 1.0,
    this.note1 = '',
    this.note2 = '',
    this.note3 = '',
    this.customFrontDetailLines,
    this.isStudentData = false,
  });

  final String companyName;
  final String logoAsset;
  final String employeeName;
  final String position;
  final String employeeId;
  final String joinDate;
  final String expireDate;
  final String address;
  final String phone;
  final String email;
  final String bloodGroup;
  final String photoPath;
  final String signaturePath;
  final Uint8List? signatureBytes;
  final bool signatureHasBorder;
  final Color signatureBorderColor;
  final double signatureBorderWidth;
  final String note1;
  final String note2;
  final String note3;
  final List<String>? customFrontDetailLines;
  final bool isStudentData;

  static const EmployeeData empty = EmployeeData();

  bool get hasPhoto => photoPath.trim().isNotEmpty;

  bool get hasSignature =>
      (signatureBytes != null && signatureBytes!.isNotEmpty) ||
      signaturePath.trim().isNotEmpty;

  List<String> get backDetailLines {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(note1);
    add(note2);
    add(note3);
    return lines;
  }

  bool get hasBackContent =>
      backDetailLines.isNotEmpty ||
      hasSignature ||
      joinDate.trim().isNotEmpty ||
      expireDate.trim().isNotEmpty;

  /// Front white zone — values only (no field labels).
  List<String> get frontDetailLines {
    if (customFrontDetailLines != null && customFrontDetailLines!.isNotEmpty) {
      return customFrontDetailLines!;
    }
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(employeeId);
    add(joinDate);
    add(bloodGroup);
    add(phone);
    add(email);
    add(address);
    return lines;
  }

  factory EmployeeData.fromCreateFlow(CreateFlowController flow) {
    return EmployeeData(
      companyName: flow.empCompanyNameCtrl.text,
      logoAsset: flow.selectedCompanyLogoAsset ?? '',
      employeeName: flow.empFullNameCtrl.text,
      position: flow.empPositionCtrl.text,
      employeeId: flow.empIdNumberCtrl.text,
      joinDate: flow.empJoinDateCtrl.text,
      expireDate: flow.empExpireDateCtrl.text,
      address: flow.empAddressCtrl.text,
      phone: flow.empPhoneCtrl.text,
      email: flow.empEmailCtrl.text,
      bloodGroup: flow.empBloodGroupCtrl.text,
      photoPath: flow.empPhotoPath.value,
      signaturePath: flow.empSignaturePath.value,
      signatureBytes: flow.empSignatureImageBytes.value,
      signatureHasBorder: flow.signatureHasBorder.value,
      signatureBorderColor: flow.currentSignatureBorderColor,
      signatureBorderWidth: flow.signatureBorderWidth.value,
      note1: flow.empNote1Ctrl.text,
      note2: flow.empNote2Ctrl.text,
      note3: flow.empNote3Ctrl.text,
    );
  }
}
