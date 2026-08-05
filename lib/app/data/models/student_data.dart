import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../modules/create_flow/controllers/create_flow_controller.dart';

import 'employee_data.dart';

/// All dynamic fields rendered on student ID card templates.
class StudentData {
  const StudentData({
    this.instituteName = '',
    this.studentName = '',
    this.fatherName = '',
    this.className = '',
    this.section = '',
    this.rollNo = '',
    this.mobileNumber = '',
    this.address = '',
    this.email = '',
    this.bloodGroup = '',
    this.validFrom = '',
    this.validTo = '',
    this.photoPath = '',
    this.signaturePath = '',
    this.signatureBytes,
    this.signatureHasBorder = false,
    this.signatureBorderColor = const Color(0xFF0F172A),
    this.signatureBorderWidth = 1.0,
    this.term1 = '',
    this.term2 = '',
    this.term3 = '',
  });

  final String instituteName;
  final String studentName;
  final String fatherName;
  final String className;
  final String section;
  final String rollNo;
  final String mobileNumber;
  final String address;
  final String email;
  final String bloodGroup;
  final String validFrom;
  final String validTo;
  final String photoPath;
  final String signaturePath;
  final Uint8List? signatureBytes;
  final bool signatureHasBorder;
  final Color signatureBorderColor;
  final double signatureBorderWidth;
  final String term1;
  final String term2;
  final String term3;

  static const StudentData empty = StudentData();

  bool get hasPhoto => photoPath.trim().isNotEmpty;

  /// Main student form fields (terms/signature/photo excluded).
  int get emptyMainFormFieldCount {
    final values = <String>[
      instituteName,
      studentName,
      fatherName,
      className,
      section,
      rollNo,
      mobileNumber,
      email,
      bloodGroup,
      address,
      validFrom,
      validTo,
    ];
    return values.where((v) => v.trim().isEmpty).length;
  }

  /// All filled → slightly tighter vertical gaps on card (avoids overflow).
  bool get useCompactFrontSpacing => emptyMainFormFieldCount == 0;

  /// More than 2 empty main fields → looser vertical gaps (fills white area).
  bool get useRelaxedFrontSpacing => emptyMainFormFieldCount > 2;

  bool get hasSignature =>
      (signatureBytes != null && signatureBytes!.isNotEmpty) ||
      signaturePath.trim().isNotEmpty;

  String get validityText {
    final from = validFrom.trim();
    final to = validTo.trim();
    if (from.isEmpty && to.isEmpty) return '';
    if (from.isNotEmpty && to.isNotEmpty) return '$from - $to';
    return from.isNotEmpty ? from : to;
  }

  static String _capitalizeWords(String input) {
    final str = input.trim();
    if (str.isEmpty) return str;
    return str.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Institute name with first letter of each word capitalized.
  String get formattedInstituteName => _capitalizeWords(instituteName);

  /// Student name with first letter of each word capitalized.
  String get formattedStudentName => _capitalizeWords(studentName);

  /// Father name with first letter of each word capitalized.
  String get formattedFatherName => _capitalizeWords(fatherName);

  /// Class/course name with first letter of each word capitalized.
  String get formattedClassName => _capitalizeWords(className);

  /// Front detail lines (Section, Roll No, Blood Group, Mobile, Address) — rendered at uniform bodyFontSize (32px).
  List<String> get frontDetailLines {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(_capitalizeWords(v));
    }

    add(rollNo);
    add(section);
    add(bloodGroup);
    add(mobileNumber);
    add(email);
    add(address);
    return lines;
  }

  /// Front body lines (legacy all-in-one).
  List<String> get frontBodyLines {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(_capitalizeWords(v));
    }

    add(fatherName);
    add(rollNo);
    add(className);
    add(section);
    add(bloodGroup);
    add(mobileNumber);
    add(email);
    add(address);
    return lines;
  }

  bool get hasFrontValidity => false;

  /// Validity moved to back side of card.
  String? get frontValidityHorizontalLine => null;

  /// Single line text for validity on back side.
  String? get backValidityText {
    final from = validFrom.trim();
    final to = validTo.trim();
    if (from.isEmpty && to.isEmpty) return null;
    if (from.isNotEmpty && to.isNotEmpty) return 'VALIDITY: $from TO $to';
    return from.isNotEmpty ? 'VALID FROM: $from' : 'VALID TILL: $to';
  }

  /// Back — terms + validity details in safe area.
  List<String> get backDetailLines {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(term1);
    add(term2);
    add(term3);

    final val = backValidityText;
    if (val != null && val.isNotEmpty) {
      add(val);
    }

    return lines;
  }

  bool get hasBackContent => backDetailLines.isNotEmpty;

  factory StudentData.fromCreateFlow(CreateFlowController flow) {
    return StudentData(
      instituteName: flow.instituteCtrl.text,
      studentName: flow.fullNameCtrl.text,
      fatherName: flow.fatherNameCtrl.text,
      className: flow.courseCtrl.text,
      section: flow.sectionCtrl.text,
      rollNo: flow.idNumberCtrl.text,
      mobileNumber: flow.phoneCtrl.text,
      address: flow.addressCtrl.text,
      email: flow.emailCtrl.text,
      bloodGroup: flow.bloodGroupCtrl.text,
      validFrom: flow.validFromCtrl.text,
      validTo: flow.validToCtrl.text,
      photoPath: flow.photoPath.value,
      signaturePath: flow.signaturePath.value,
      signatureBytes: flow.signatureImageBytes.value,
      signatureHasBorder: flow.signatureHasBorder.value,
      signatureBorderColor: flow.currentSignatureBorderColor,
      signatureBorderWidth: flow.signatureBorderWidth.value,
      term1: flow.term1Ctrl.text,
      term2: flow.term2Ctrl.text,
      term3: flow.term3Ctrl.text,
    );
  }

  StudentData copyWith({
    String? instituteName,
    String? studentName,
    String? fatherName,
    String? className,
    String? section,
    String? rollNo,
    String? mobileNumber,
    String? address,
    String? email,
    String? bloodGroup,
    String? validFrom,
    String? validTo,
    String? photoPath,
    String? signaturePath,
    Uint8List? signatureBytes,
    String? term1,
    String? term2,
    String? term3,
  }) {
    return StudentData(
      instituteName: instituteName ?? this.instituteName,
      studentName: studentName ?? this.studentName,
      fatherName: fatherName ?? this.fatherName,
      className: className ?? this.className,
      section: section ?? this.section,
      rollNo: rollNo ?? this.rollNo,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      photoPath: photoPath ?? this.photoPath,
      signaturePath: signaturePath ?? this.signaturePath,
      signatureBytes: signatureBytes ?? this.signatureBytes,
      term1: term1 ?? this.term1,
      term2: term2 ?? this.term2,
      term3: term3 ?? this.term3,
    );
  }

  EmployeeData toEmployeeData() {
    final detailLines = <String>[];
    void add(String val) {
      final v = val.trim();
      if (v.isNotEmpty) detailLines.add(v);
    }

    // Student Form Order: Father Name -> Roll No -> Phone -> Email -> Blood Group -> Address
    if (fatherName.trim().isNotEmpty) {
      add(_capitalizeWords(fatherName));
    }
    add(rollNo);
    add(mobileNumber);
    add(email);
    if (bloodGroup.trim().isNotEmpty) {
      add(bloodGroup.toUpperCase());
    }
    add(address);

    final courseClass = formattedClassName.isNotEmpty && section.trim().isNotEmpty
        ? '$formattedClassName - ${section.trim().toUpperCase()}'
        : (formattedClassName.isNotEmpty ? formattedClassName : section.trim().toUpperCase());

    return EmployeeData(
      companyName: formattedInstituteName,
      employeeName: formattedStudentName,
      position: courseClass,
      employeeId: rollNo,
      joinDate: validFrom,
      expireDate: validTo,
      phone: mobileNumber,
      email: email,
      bloodGroup: bloodGroup,
      photoPath: photoPath,
      signaturePath: signaturePath,
      signatureBytes: signatureBytes,
      signatureHasBorder: signatureHasBorder,
      signatureBorderColor: signatureBorderColor,
      signatureBorderWidth: signatureBorderWidth,
      note1: term1,
      note2: term2,
      note3: term3,
      customFrontDetailLines: detailLines,
    );
  }
}
