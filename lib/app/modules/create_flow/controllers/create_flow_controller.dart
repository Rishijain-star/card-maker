import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../id_templates/assets/company_id_template_assets.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

import '../../../core/config/razorpay_config.dart';
import '../../../core/widgets/shimmer_skeleton_loader.dart';
import '../../../core/widgets/top_slide_notice.dart';
import '../../../data/models/app_product.dart';
import '../../../data/models/saved_design.dart';
import '../../../data/models/student_data.dart';
import '../../../routes/app_pages.dart';
import '../../../services/app_loading_service.dart';
import '../../../services/card_pdf_export_service.dart';
import '../../../services/design_export_service.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../services/template_capture_service.dart';
import '../views/profile_image_crop_view.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../../id_templates/widgets/student_id_card_side.dart';

class CreateFlowController extends GetxController {
  static const int freeSaveLimit = 5;

  final RxString selectedService = 'ID Card'.obs;
  final RxString selectedLayout = 'Portrait'.obs;
  final RxInt selectedTemplate = 0.obs;
  final RxInt selectedFont = 0.obs;
  final RxDouble fontSizeScale = 1.0.obs;
  final RxMap<String, double> savedTemplateFontScales = <String, double>{}.obs;

  String get currentTemplateKey =>
      '${selectedService.value}_${selectedLayout.value}_${selectedTemplate.value}';

  void loadFontSizeScaleForCurrentTemplate() {
    final key = currentTemplateKey;
    if (savedTemplateFontScales.containsKey(key)) {
      fontSizeScale.value = savedTemplateFontScales[key]!;
    } else {
      fontSizeScale.value = 1.0;
    }
  }

  void setFontSizeScale(double scale) {
    fontSizeScale.value = scale.clamp(0.70, 1.50);
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
    update(<Object>['template_screen', 'student_preview', 'employee_preview', 'lanyard_preview', 'live_preview']);
  }

  void incrementFontSizeScale() {
    setFontSizeScale(fontSizeScale.value + 0.05);
  }

  void decrementFontSizeScale() {
    setFontSizeScale(fontSizeScale.value - 0.05);
  }

  void resetFontSizeScale() {
    fontSizeScale.value = 1.0;
    savedTemplateFontScales.remove(currentTemplateKey);
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
    update(<Object>['template_screen', 'student_preview', 'employee_preview', 'lanyard_preview', 'live_preview']);
  }

  final RxInt selectedColor = 0.obs;
  /// 0 = no logo; 1+ maps to [CompanyIdTemplateAssets.logoPickerOptions].
  final RxInt selectedCompanyLogo = 0.obs;
  final RxBool isLoggedIn = false.obs;
  final RxList<SavedDesign> savedDesigns = <SavedDesign>[].obs;
  final RxInt lifetimeSaveCount = 0.obs;
  final RxBool isPremium = false.obs;
  final RxBool isSavingCard = false.obs;
  final RxBool isExportingPdf = false.obs;
  final RxBool isTemplatesLoading = true.obs;

  void startTemplatesLoading() {
    isTemplatesLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1300), () {
      isTemplatesLoading.value = false;
    });
  }

  final RxString photoPath = ''.obs;
  final RxString signaturePath = ''.obs;
  final Rx<Uint8List?> signatureImageBytes = Rx<Uint8List?>(null);

  final RxBool signatureHasBorder = false.obs;
  final RxInt signatureBorderColorIndex = 0.obs;
  final RxDouble signatureBorderWidth = 1.0.obs;

  static const List<Color> signatureBorderColors = [
    Color(0xFF0F172A), // Black / Dark Slate
    Color(0xFF1E3A8A), // Navy Blue
    Color(0xFFB71C1C), // Crimson Red
    Color(0xFF15803D), // Emerald Green
    Color(0xFFD97706), // Gold / Amber
    Color(0xFFFFFFFF), // Pure White
  ];

  Color get currentSignatureBorderColor =>
      signatureBorderColors[signatureBorderColorIndex.value.clamp(0, signatureBorderColors.length - 1)];

  /// After "Save Card + Create New", Continue skips template picker.
  bool _quickCreateAnother = false;

  /// Editable demo values — change anytime; not read-only.
  static const String kDefaultInstitute = 'city public school';
  static const String kDefaultStudentName = 'rishi jain';
  static const String kDefaultFatherName = 'sharad jain';
  static const String kDefaultCourse = 'bca';
  static const String kDefaultSection = 'A';
  static const String kDefaultRollNo = '12345677';
  static const String kDefaultPhone = '8085909343';
  static const String kDefaultEmail = '';
  static const String kDefaultBloodGroup = 'A+';
  static const String kDefaultAddress = '33 d new angin nagar indore';
  static const String kDefaultValidFrom = '04-06-2026';
  static const String kDefaultValidTo = '08-10-2026';
  static const String kDefaultTerm1 = 'First term: 85%';
  static const String kDefaultTerm2 = 'Second term: 78%';
  static const String kDefaultTerm3 = 'Third term: 82%';

  static const String kDefaultCompany = 'TCS';
  static const String kDefaultEmployeeName = 'John Thomouse';
  static const String kDefaultPosition = 'Software Developer';
  static const String kDefaultEmployeeId = '510484454';
  static const String kDefaultEmployeeJoin = '03-08-2016';
  static const String kDefaultEmployeeExpire = '03-08-2020';
  static const String kDefaultEmployeeNote1 =
      'Lorem ipsum is simply dummy text of the printing industry.';
  static const String kDefaultEmployeeNote2 =
      'Lorem ipsum has been the industry standard dummy text.';
  static const String kDefaultEmployeeNote3 =
      'Lorem ipsum is simply dummy text of the typesetting industry.';

  final instituteCtrl = TextEditingController(text: kDefaultInstitute);
  final fullNameCtrl = TextEditingController(text: kDefaultStudentName);
  final fatherNameCtrl = TextEditingController(text: kDefaultFatherName);
  final courseCtrl = TextEditingController(text: kDefaultCourse);
  final sectionCtrl = TextEditingController(text: kDefaultSection);
  final term1Ctrl = TextEditingController(text: kDefaultTerm1);
  final term2Ctrl = TextEditingController(text: kDefaultTerm2);
  final term3Ctrl = TextEditingController(text: kDefaultTerm3);
  final bloodGroupCtrl = TextEditingController(text: kDefaultBloodGroup);
  final phoneCtrl = TextEditingController(text: kDefaultPhone);
  final emailCtrl = TextEditingController(text: '');
  final addressCtrl = TextEditingController(text: kDefaultAddress);
  final expiryDateCtrl = TextEditingController();
  final validFromCtrl = TextEditingController(text: kDefaultValidFrom);
  final validToCtrl = TextEditingController(text: kDefaultValidTo);
  final idNumberCtrl = TextEditingController(text: kDefaultRollNo);
  final departmentCtrl = TextEditingController();
  final logoCtrl = TextEditingController(text: 'ID-Shaydi');
  final signatureCtrl = TextEditingController(text: 'Upload pending');

  final List<Color> palette = <Color>[
    const Color(0xFF2563EB),
    const Color(0xFF7C3AED),
    const Color(0xFFEC4899),
    const Color(0xFFF97316),
  ];

  final List<String> fonts = List<String>.from(IdCardTypography.fontOptions);

  String get selectedFontFamily => fonts[selectedFont.value.clamp(0, fonts.length - 1)];

  bool get isEmployeeService => selectedService.value == 'Employee ID Card';

  bool get isLanyardService => selectedService.value == 'Lanyard';

  bool get isStudentService => selectedService.value == 'Student ID Card';

  List<String> get companyLogoOptions =>
      CompanyIdTemplateAssets.logoPickerOptions;

  String? get selectedCompanyLogoAsset =>
      CompanyIdTemplateAssets.logoAssetForPickerIndex(selectedCompanyLogo.value);

  /// Live student PNG templates (add new entries here as you ship layouts).
  final List<Map<String, dynamic>> studentTemplates = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 0,
      'title': 'Template 1',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 0,
    },
    <String, dynamic>{
      'id': 1,
      'title': 'Template 2',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 1,
    },
    <String, dynamic>{
      'id': 2,
      'title': 'Template 3',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 2,
    },
    <String, dynamic>{
      'id': 3,
      'title': 'Template 4',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 3,
    },
    <String, dynamic>{
      'id': 4,
      'title': 'Template 5',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 4,
    },
    <String, dynamic>{
      'id': 5,
      'title': 'Template 6',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 5,
    },
    <String, dynamic>{
      'id': 6,
      'title': 'Template 7',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 6,
    },
    <String, dynamic>{
      'id': 7,
      'title': 'Template 8',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 7,
    },
    <String, dynamic>{
      'id': 8,
      'title': 'Template 9',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 8,
    },
    <String, dynamic>{
      'id': 9,
      'title': 'Template 10',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 9,
    },
    <String, dynamic>{
      'id': 10,
      'title': 'Template 11',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 10,
    },
    <String, dynamic>{
      'id': 11,
      'title': 'Template 13',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 11,
      'frontOnly': true,
    },
    <String, dynamic>{
      'id': 12,
      'title': 'Template 14',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 12,
      'frontOnly': true,
    },
    <String, dynamic>{
      'id': 13,
      'title': 'Template 15',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 13,
      'frontOnly': true,
      'landscape': true,
    },
    <String, dynamic>{
      'id': 14,
      'title': 'Template 16',
      'category': 'Student',
      'premium': false,
      'studentEngine': true,
      'variant': 14,
      'frontOnly': true,
      'landscape': true,
    },
  ];

  /// Single-sided student templates (no back swipe / back preview).
  bool studentTemplateIsFrontOnly(int index) {
    if (index < 0 || index >= studentTemplates.length) return false;
    return studentTemplates[index]['frontOnly'] == true;
  }

  /// Landscape canvas (e.g. Template 15 deer card).
  bool studentTemplateIsLandscape(int index) {
    if (index < 0 || index >= studentTemplates.length) return false;
    return studentTemplates[index]['landscape'] == true;
  }

  final isLanyardRotated = false.obs;
  final isLanyardNeckMockupMode = false.obs;
  final lanyardRepeatCount = 3.obs;
  final lanyardTextOffsetX = 0.0.obs;
  final lanyardTextOffsetY = 0.0.obs;
  final lanyardLogoTextSpacing = 6.0.obs;

  void setLanyardRepeatCount(int count) {
    lanyardRepeatCount.value = count.clamp(2, 6);
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  void setLanyardTextOffsetX(double val) {
    lanyardTextOffsetX.value = val;
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  void setLanyardTextOffsetY(double val) {
    lanyardTextOffsetY.value = val;
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  void setLanyardLogoTextSpacing(double val) {
    lanyardLogoTextSpacing.value = val.clamp(0.0, 40.0);
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  final lanyardCustomTextColorHex = RxnInt();

  void setLanyardTextColorHex(int? colorHex) {
    lanyardCustomTextColorHex.value = colorHex;
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  void resetLanyardTextOffset() {
    lanyardTextOffsetX.value = 0.0;
    lanyardTextOffsetY.value = 0.0;
    lanyardLogoTextSpacing.value = 6.0;
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  final List<Map<String, dynamic>> lanyardTemplates = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 0,
      'title': 'Blue Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 0,
    },
    <String, dynamic>{
      'id': 1,
      'title': 'Blue & Red Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 1,
    },
    <String, dynamic>{
      'id': 2,
      'title': 'Green Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 2,
    },
    <String, dynamic>{
      'id': 3,
      'title': 'Green & Black Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 3,
    },
    <String, dynamic>{
      'id': 4,
      'title': 'Red Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 4,
    },
    <String, dynamic>{
      'id': 5,
      'title': 'White & Blue Ribbon Lanyard',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 5,
    },
    <String, dynamic>{
      'id': 6,
      'title': 'Gold & Diamond Artwork',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 6,
    },
    <String, dynamic>{
      'id': 7,
      'title': 'Cyber Wave Artwork',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 7,
    },
    <String, dynamic>{
      'id': 8,
      'title': 'Royal Purple Wave Artwork',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 8,
    },
    <String, dynamic>{
      'id': 9,
      'title': 'Luxury Black Gold Velvet',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 9,
    },
    <String, dynamic>{
      'id': 10,
      'title': 'Emerald & Platinum Executive',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 10,
    },
    <String, dynamic>{
      'id': 11,
      'title': 'Rose Gold & Ruby Luxury',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 11,
    },
    <String, dynamic>{
      'id': 12,
      'title': 'Yellow & Fire Geometric Sport',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 12,
    },
    <String, dynamic>{
      'id': 13,
      'title': 'Coral Curved Diamond Artwork',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 13,
    },
    <String, dynamic>{
      'id': 14,
      'title': 'Red & Black Slash Divider Sport',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 14,
    },
    <String, dynamic>{
      'id': 15,
      'title': 'Navy & Pink Wide Block',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 15,
    },
    <String, dynamic>{
      'id': 16,
      'title': 'Vibrant Rainbow Spectrum Festival',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 16,
    },
    <String, dynamic>{
      'id': 17,
      'title': 'Neon Purple & Royal Blue Halftone',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 17,
    },
    <String, dynamic>{
      'id': 18,
      'title': 'Black & Crimson Yellow Diamond Slash',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 18,
    },
    <String, dynamic>{
      'id': 19,
      'title': 'Dual Blue Parallelogram Block',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 19,
    },
    <String, dynamic>{
      'id': 20,
      'title': 'Orange-Yellow Horizontal Gradient',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 20,
    },
    <String, dynamic>{
      'id': 21,
      'title': 'Cyan-Lime Diagonal Slash Gradient',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 21,
    },
    <String, dynamic>{
      'id': 22,
      'title': 'Yellow Dot Matrix & Double Slash',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 22,
    },
    <String, dynamic>{
      'id': 23,
      'title': 'Red Dense Slashes & Dark Pill',
      'category': 'Lanyard',
      'lanyardEngine': true,
      'variant': 23,
    },
  ];

  final List<Map<String, dynamic>> employeeTemplates = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 0,
      'title': 'Company Template 1',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 0,
    },
    <String, dynamic>{
      'id': 1,
      'title': 'Company Template 2',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 1,
    },
    <String, dynamic>{
      'id': 2,
      'title': 'Company Template 3',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 2,
    },
    <String, dynamic>{
      'id': 3,
      'title': 'Company Template 4',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 3,
    },
    <String, dynamic>{
      'id': 4,
      'title': 'Company Template 5',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 4,
    },
    <String, dynamic>{
      'id': 5,
      'title': 'Company Template 6',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 5,
    },
    <String, dynamic>{
      'id': 6,
      'title': 'Company Template 7',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 6,
    },
    <String, dynamic>{
      'id': 7,
      'title': 'Company Template 8',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 7,
    },
    <String, dynamic>{
      'id': 8,
      'title': 'Company Template 9',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 8,
    },
    <String, dynamic>{
      'id': 9,
      'title': 'Company Template 10',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 9,
    },
    <String, dynamic>{
      'id': 10,
      'title': 'Company Template 11',
      'category': 'Company',
      'premium': false,
      'employeeEngine': true,
      'variant': 10,
    },
  ];

  List<Map<String, dynamic>> get activeTemplates {
    if (isLanyardService) return lanyardTemplates;
    if (isEmployeeService) return employeeTemplates;
    return studentTemplates;
  }

  String templateTitleAt(int index) {
    final list = activeTemplates;
    if (index < 0 || index >= list.length) return 'Template';
    return list[index]['title'] as String? ?? 'Template';
  }

  /// Pre-fills employee demo when opening Employee ID flow.
  void applyEmployeeDemoFields() {
    instituteCtrl.text = kDefaultCompany;
    fullNameCtrl.text = kDefaultEmployeeName;
    courseCtrl.text = kDefaultPosition;
    idNumberCtrl.text = kDefaultEmployeeId;
    expiryDateCtrl.text = kDefaultEmployeeJoin;
    validToCtrl.text = kDefaultEmployeeExpire;
    departmentCtrl.text = '';
    phoneCtrl.text = kDefaultPhone;
    emailCtrl.text = kDefaultEmail;
    bloodGroupCtrl.text = kDefaultBloodGroup;
    fatherNameCtrl.text = '';
    sectionCtrl.text = '';
    addressCtrl.text = '';
    validFromCtrl.text = '';
    term1Ctrl.text = kDefaultEmployeeNote1;
    term2Ctrl.text = kDefaultEmployeeNote2;
    term3Ctrl.text = kDefaultEmployeeNote3;
    selectedCompanyLogo.value = 0;
    selectedTemplate.value = 0;
    update(<Object>['template_screen', 'employee_preview', 'live_preview']);
  }

  /// Pre-fills lanyard demo when opening Lanyard flow.
  void applyLanyardDemoFields() {
    instituteCtrl.text = kDefaultInstitute;
    fullNameCtrl.text = kDefaultStudentName;
    courseCtrl.text = 'STUDENT';
    fatherNameCtrl.text = '';
    sectionCtrl.text = '';
    idNumberCtrl.text = '';
    phoneCtrl.text = '';
    emailCtrl.text = '';
    bloodGroupCtrl.text = '';
    addressCtrl.text = '';
    validFromCtrl.text = '';
    validToCtrl.text = '';
    expiryDateCtrl.text = '';
    departmentCtrl.text = '';
    term1Ctrl.text = '';
    term2Ctrl.text = '';
    term3Ctrl.text = '';
    photoPath.value = '';
    selectedTemplate.value = 0;
    selectedColor.value = 2;
    update(<Object>['template_screen', 'lanyard_preview', 'live_preview']);
  }

  final SignatureController signatureDrawController = SignatureController(
    penStrokeWidth: 2.4,
    penColor: const Color(0xFF0F172A),
  );

  bool get isPremiumActive => isPremium.value;

  int get saveLimit =>
      isPremiumActive ? RazorpayConfig.premiumSaveLimit : freeSaveLimit;

  bool get canSaveMoreDesigns => lifetimeSaveCount.value < saveLimit;

  bool get showPremiumOption =>
      !isPremiumActive && lifetimeSaveCount.value >= freeSaveLimit;

  void _loadPremiumStatus() {
    isPremium.value = LocalStorageService().getIsPremium();
  }

  Future<void> activatePremium() async {
    isPremium.value = true;
    await LocalStorageService().setIsPremium(true);
    await _addPremiumWelcomeDesign();
  }

  Future<void> _addPremiumWelcomeDesign() async {
    if (savedDesigns.any((d) => d.templateName.startsWith('Premium Welcome'))) return;

    final pairId = 'premium_${DateTime.now().millisecondsSinceEpoch}';
    const welcomeData = StudentData(
      instituteName: kDefaultInstitute,
      studentName: kDefaultStudentName,
      fatherName: kDefaultFatherName,
      className: kDefaultCourse,
      section: kDefaultSection,
      rollNo: kDefaultRollNo,
      mobileNumber: kDefaultPhone,
      email: kDefaultEmail,
      bloodGroup: kDefaultBloodGroup,
      address: kDefaultAddress,
      validFrom: kDefaultValidFrom,
      validTo: kDefaultValidTo,
      term1: kDefaultTerm1,
      term2: kDefaultTerm2,
      term3: kDefaultTerm3,
    );

    final frontBytes = await TemplateCaptureService.captureStudentCard(
      templateIndex: 0,
      data: welcomeData,
      side: StudentIdCardSide.front,
      fontFamily: 'Cinzel',
    );
    final backBytes = await TemplateCaptureService.captureStudentCard(
      templateIndex: 0,
      data: welcomeData,
      side: StudentIdCardSide.back,
      fontFamily: 'Cinzel',
    );

    String frontPath = '';
    String backPath = '';
    var galleryOk = false;

    if (frontBytes != null) {
      frontPath = await DesignExportService.saveToAppDir(
            frontBytes,
            'id_shaydi_${pairId}_front.png',
          ) ??
          '';
      galleryOk = await DesignExportService.saveToGalleryReliable(
        frontBytes,
        name: 'ID-Shaydi_${pairId}_front',
      );
    }
    if (backBytes != null) {
      backPath = await DesignExportService.saveToAppDir(
            backBytes,
            'id_shaydi_${pairId}_back.png',
          ) ??
          '';
      final backGalleryOk = await DesignExportService.saveToGalleryReliable(
        backBytes,
        name: 'ID-Shaydi_${pairId}_back',
      );
      galleryOk = galleryOk && backGalleryOk;
    }

    final design = SavedDesign(
      templatePairId: pairId,
      title: kDefaultStudentName,
      frontImagePath: frontPath,
      backImagePath: backPath,
      service: 'Student ID Card',
      templateName: 'Premium Welcome · 4242',
      fontFamily: 'Cinzel',
      savedAtMs: int.parse(pairId.split('_').last),
      instituteName: kDefaultInstitute,
      studentName: kDefaultStudentName,
    );
    savedDesigns.insert(0, design);
    await _persistSavedDesigns();

    if (!galleryOk) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx == null) return;
      TopSlideNotice.show(
        context: ctx,
        title: 'Premium unlocked',
        message: 'Welcome card saved to your gallery.',
      );
    });
  }

  List<SavedDesign> savedDesignsForProduct(
    dynamic product, {
    DateTime? onDate,
  }) {
    Iterable<SavedDesign> list = savedDesigns;
    if (product is AppProduct) {
      list = list.where((d) => product.matchesSavedDesignService(d.service));
    } else {
      list = list.where((d) => _matchesProduct(d, '$product'));
    }
    if (onDate != null) {
      list = list.where((d) => _isSameDay(d.savedAtMs, onDate));
    }
    return list.toList();
  }

  bool _matchesProduct(SavedDesign design, String productTitle) {
    switch (productTitle) {
      case 'ID CARD':
        return design.service == 'Student ID Card' ||
            design.service == 'Employee ID Card' ||
            design.service == 'ID Card';
      case 'LANYARD':
        return design.service == 'Lanyard';
      default:
        return false;
    }
  }

  bool _isSameDay(int savedAtMs, DateTime date) {
    final saved = DateTime.fromMillisecondsSinceEpoch(savedAtMs);
    return saved.year == date.year &&
        saved.month == date.month &&
        saved.day == date.day;
  }

  bool _currentDesignHasBack() {
    if (isLanyardService) return false;
    if (!Get.isRegistered<TemplateController>()) return false;
    final templateCtrl = Get.find<TemplateController>();
    if (isEmployeeService) {
      return templateCtrl.employeeData.value.hasBackContent;
    }
    if (studentTemplateIsFrontOnly(selectedTemplate.value)) return false;
    return templateCtrl.studentData.value.hasBackContent;
  }

  void _loadLifetimeSaveCount() {
    final storage = LocalStorageService();
    var count = storage.getLifetimeSaveCount();
    if (count == 0 && savedDesigns.isNotEmpty) {
      count = savedDesigns.length;
      storage.setLifetimeSaveCount(count);
    }
    lifetimeSaveCount.value = count;
  }

  Future<void> _incrementLifetimeSaveCount() async {
    lifetimeSaveCount.value++;
    await LocalStorageService().setLifetimeSaveCount(lifetimeSaveCount.value);
  }

  void _loadSavedDesigns() {
    final storage = LocalStorageService();
    final json = storage.getSavedDesignsJson();
    if (json.isNotEmpty) {
      savedDesigns.assignAll(SavedDesign.listFromJsonString(json));
      return;
    }
    // Legacy text-only entries (no image).
    final legacy = storage.getSavedDesigns();
    if (legacy.isEmpty) return;
    savedDesigns.assignAll(
      legacy.asMap().entries.map(
        (e) => SavedDesign(
          templatePairId: 'legacy_${e.key}',
          title: e.value,
          frontImagePath: '',
          backImagePath: '',
          service: selectedService.value,
          templateName: '',
          fontFamily: selectedFontFamily,
          savedAtMs: DateTime.now().millisecondsSinceEpoch - e.key,
          instituteName: '',
          studentName: e.value,
        ),
      ),
    );
  }

  Future<void> _persistSavedDesigns() async {
    await LocalStorageService().setSavedDesignsJson(
      SavedDesign.listToJsonString(savedDesigns.toList()),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedDesigns();
    _loadLifetimeSaveCount();
    _loadPremiumStatus();
    if (isLanyardService) {
      applyLanyardDemoFields();
    } else if (isEmployeeService) {
      applyEmployeeDemoFields();
    } else {
      applyStudentDemoFields();
    }
  }

  /// Pre-fills student demo fields (editable).
  void applyStudentDemoFields() {
    instituteCtrl.text = kDefaultInstitute;
    fullNameCtrl.text = kDefaultStudentName;
    fatherNameCtrl.text = kDefaultFatherName;
    courseCtrl.text = kDefaultCourse;
    sectionCtrl.text = kDefaultSection;
    idNumberCtrl.text = kDefaultRollNo;
    phoneCtrl.text = kDefaultPhone;
    emailCtrl.text = kDefaultEmail;
    bloodGroupCtrl.text = kDefaultBloodGroup;
    addressCtrl.text = kDefaultAddress;
    validFromCtrl.text = kDefaultValidFrom;
    validToCtrl.text = kDefaultValidTo;
    expiryDateCtrl.text = '';
    departmentCtrl.text = '';
    term1Ctrl.text = kDefaultTerm1;
    term2Ctrl.text = kDefaultTerm2;
    term3Ctrl.text = kDefaultTerm3;
    selectedTemplate.value = 0;
    loadFontSizeScaleForCurrentTemplate();
    update(<Object>['template_screen', 'student_preview', 'live_preview']);
  }

  String? validateEmail(String value) {
    return null;
  }

  String? validatePhone(String value) {
    return null;
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) return true;
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  Future<void> pickFromCamera() async {
    try {
      final granted = await _requestCameraPermission();
      if (!granted) {
        Get.snackbar('Permission required', 'Camera permission is needed.');
        return;
      }
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );
      if (file != null) {
        final croppedPath = await Get.to<String>(
          () => ProfileImageCropScreen(imagePath: file.path),
        );
        if (croppedPath != null && croppedPath.isNotEmpty) {
          photoPath.value = croppedPath;
        } else {
          photoPath.value = file.path;
        }
      }
    } catch (e) {
      Get.snackbar('Photo Notice', 'Unable to capture photo: $e');
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final granted = await _requestGalleryPermission();
      if (!granted) {
        Get.snackbar('Permission required', 'Gallery permission is needed.');
        return;
      }
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file != null) {
        final croppedPath = await Get.to<String>(
          () => ProfileImageCropScreen(imagePath: file.path),
        );
        if (croppedPath != null && croppedPath.isNotEmpty) {
          photoPath.value = croppedPath;
        } else {
          photoPath.value = file.path;
        }
      }
    } catch (e) {
      Get.snackbar('Photo Notice', 'Unable to pick photo: $e');
    }
  }

  void showPhotoSourcePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEFF6FF),
                    child: Icon(Icons.camera_alt_rounded, color: Color(0xFF2563EB)),
                  ),
                  title: const Text(
                    'Take Photo with Camera',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickFromCamera();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF0FDF4),
                    child: Icon(Icons.photo_library_rounded, color: Color(0xFF16A34A)),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickSignatureFromGallery() async {
    final granted = await _requestGalleryPermission();
    if (!granted) {
      Get.snackbar('Permission required', 'Gallery permission is needed.');
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file != null) {
      final croppedPath = await Get.to<String>(
        () => ProfileImageCropScreen(imagePath: file.path),
      );
      signatureImageBytes.value = null;
      signaturePath.value = (croppedPath != null && croppedPath.isNotEmpty) ? croppedPath : file.path;
      if (Get.isRegistered<TemplateController>()) {
        Get.find<TemplateController>().refreshCardData();
      }
    }
  }

  Future<void> pickSignatureFromCamera() async {
    final granted = await _requestCameraPermission();
    if (!granted) {
      Get.snackbar('Permission required', 'Camera permission is needed.');
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 90,
    );
    if (file != null) {
      final croppedPath = await Get.to<String>(
        () => ProfileImageCropScreen(imagePath: file.path),
      );
      signatureImageBytes.value = null;
      signaturePath.value = (croppedPath != null && croppedPath.isNotEmpty) ? croppedPath : file.path;
      if (Get.isRegistered<TemplateController>()) {
        Get.find<TemplateController>().refreshCardData();
      }
    }
  }

  Future<void> cropExistingSignature() async {
    final currentPath = signaturePath.value;
    if (currentPath.isEmpty) {
      Get.snackbar('Signature Notice', 'No image file to crop. Please pick a signature from Gallery or Camera.');
      return;
    }
    final croppedPath = await Get.to<String>(
      () => ProfileImageCropScreen(imagePath: currentPath),
    );
    if (croppedPath != null && croppedPath.isNotEmpty) {
      signaturePath.value = croppedPath;
      if (Get.isRegistered<TemplateController>()) {
        Get.find<TemplateController>().refreshCardData();
      }
    }
  }

  void clearSignature() {
    signaturePath.value = '';
    signatureImageBytes.value = null;
    signatureCtrl.clear();
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
  }

  Future<void> saveDrawnSignature() async {
    final bytes = await signatureDrawController.toPngBytes();
    if (bytes == null) return;
    signatureImageBytes.value = bytes;
    signaturePath.value = '';
    signatureCtrl.text = 'Signature drawn';
  }

  void markLoginSuccess() {
    isLoggedIn.value = true;
  }

  void setSelectedTemplate(int index) {
    selectedTemplate.value = index;
    loadFontSizeScaleForCurrentTemplate();
    if (Get.isRegistered<TemplateController>()) {
      Get.find<TemplateController>().refreshCardData();
    }
    update(<Object>['template_screen', 'student_preview', 'employee_preview', 'lanyard_preview', 'live_preview']);
  }

  void showPremiumLimitDialog() {
    Get.dialog<void>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Save limit reached'),
        content: Text(
          'You can save up to $freeSaveLimit designs for free. '
          'Subscribe to Premium (₹199) to save up to ${RazorpayConfig.premiumSaveLimit} templates.',
        ),
        actions: [
          TextButton(
            onPressed: Get.back<void>,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back<void>();
              Get.toNamed<void>(Routes.PREMIUM_SUBSCRIBE);
            },
            child: const Text('Premium Subscription'),
          ),
        ],
      ),
    );
  }

  Future<bool> saveDesignFromPreview(GlobalKey exportKey) async {
    if (!canSaveMoreDesigns) {
      showPremiumLimitDialog();
      return false;
    }

    await Future<void>.delayed(const Duration(milliseconds: 120));

    final pairId = DateTime.now().millisecondsSinceEpoch.toString();
    final instituteName = instituteCtrl.text.trim();
    final studentName = fullNameCtrl.text.trim().isEmpty
        ? 'Untitled Design'
        : fullNameCtrl.text.trim();
    final title = studentName;
    final hasBack = _currentDesignHasBack();

    Uint8List? frontBytes;
    if (isLanyardService) {
      frontBytes = await DesignExportService.capturePng(exportKey);
    } else {
      frontBytes = await TemplateCaptureService.captureCurrentSide(
        side: StudentIdCardSide.front,
        onScreenFrontKey: exportKey,
      );
    }

    if (frontBytes == null) {
      Get.snackbar(
        'Save failed',
        'Could not capture your design. Try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    Uint8List? backBytes;
    if (hasBack) {
      backBytes = await TemplateCaptureService.captureCurrentSide(
        side: StudentIdCardSide.back,
      );
    }

    final frontFileName = 'id_shaydi_${pairId}_front.png';
    final frontPath = await DesignExportService.saveToAppDir(
      frontBytes,
      frontFileName,
    );
    if (frontPath == null) {
      Get.snackbar(
        'Save failed',
        'Could not save design on device.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    var galleryOk = await DesignExportService.saveToGalleryReliable(
      frontBytes,
      name: 'ID-Shaydi_${pairId}_front',
    );

    var backPath = '';
    if (backBytes != null) {
      backPath = await DesignExportService.saveToAppDir(
            backBytes,
            'id_shaydi_${pairId}_back.png',
          ) ??
          '';
      final backGalleryOk = await DesignExportService.saveToGalleryReliable(
        backBytes,
        name: 'ID-Shaydi_${pairId}_back',
      );
      galleryOk = galleryOk && backGalleryOk;
    }

    // Save current font size scale to permanent memory for this template only when user saves
    savedTemplateFontScales[currentTemplateKey] = fontSizeScale.value;

    final design = SavedDesign(
      templatePairId: pairId,
      title: title,
      frontImagePath: frontPath,
      backImagePath: backPath,
      service: selectedService.value,
      templateName: templateTitleAt(selectedTemplate.value),
      fontFamily: selectedFontFamily,
      fontSizeScale: fontSizeScale.value,
      savedAtMs: int.parse(pairId),
      instituteName: instituteName,
      studentName: studentName,
      lanyardVariant: isLanyardService ? selectedTemplate.value : null,
      lanyardRepeatCount: lanyardRepeatCount.value,
      lanyardTextOffsetX: lanyardTextOffsetX.value,
      lanyardTextOffsetY: lanyardTextOffsetY.value,
      lanyardLogoTextSpacing: lanyardLogoTextSpacing.value,
      lanyardTextColorHex: lanyardCustomTextColorHex.value,
      logoPath: photoPath.value,
    );
    savedDesigns.insert(0, design);
    await _persistSavedDesigns();
    await _incrementLifetimeSaveCount();

    final noticeTitle = 'Design saved';
    final noticeMessage = galleryOk
        ? hasBack
            ? 'Saved to Saved Cards & gallery (front + back).'
            : 'Saved to Saved Cards & your phone gallery.'
        : 'Saved to Saved Cards. Allow Photos access in settings for gallery save.';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx != null) {
        TopSlideNotice.show(
          context: ctx,
          title: noticeTitle,
          message: noticeMessage,
        );
      }
    });
    return true;
  }

  void resetQuickCreate() {
    _quickCreateAnother = false;
  }

  /// Called from details form after validation — normal or batch-create flow.
  void navigateAfterFormSubmit() {
    if (_quickCreateAnother) {
      if (Get.isRegistered<TemplateController>()) {
        final templateCtrl = Get.find<TemplateController>();
        templateCtrl.selectTemplate(selectedTemplate.value);
        templateCtrl.openTemplateEditor(selectedTemplate.value);
        return;
      }
    }
    startTemplatesLoading();
    Get.toNamed<void>(Routes.TEMPLATES);
  }

  Future<void> executeSaveDesignWorkflow(
    GlobalKey exportKey, {
    required bool createNew,
    required BuildContext context,
  }) async {
    if (isSavingCard.value) return;
    if (!canSaveMoreDesigns) {
      showPremiumLimitDialog();
      return;
    }

    FiveDotLoadingOverlay.show(
      context,
      message: createNew
          ? 'Saving card & preparing next entry...'
          : 'Saving your card design...',
    );

    try {
      final saved = await saveDesignFromPreview(exportKey);
      if (context.mounted) {
        FiveDotLoadingOverlay.hide(context);
      }
      if (!saved) return;

      if (createNew) {
        // Enable quick batch mode for continuous card creation on SAME template
        _quickCreateAnother = true;

        // Reset student-specific details for next card entry
        fullNameCtrl.clear();
        idNumberCtrl.clear();
        if (!isLanyardService) {
          photoPath.value = '';
          signaturePath.value = '';
          signatureImageBytes.value = null;
        }

        var poppedToForm = false;
        Get.until((route) {
          if (route.settings.name == Routes.DETAILS_FORM) {
            poppedToForm = true;
            return true;
          }
          return false;
        });
        if (!poppedToForm) {
          Get.offNamedUntil(Routes.DETAILS_FORM, (route) => route.isFirst);
        }
      } else {
        _quickCreateAnother = false;
        Get.toNamed<void>(Routes.SAVE_SUCCESS);
      }
    } catch (e) {
      if (context.mounted) {
        FiveDotLoadingOverlay.hide(context);
      }
      Get.snackbar('Save Error', 'Failed to save design: $e');
    }
  }

  void handleSaveCancel() {
    _quickCreateAnother = false;
    var poppedToTemplates = false;
    Get.until((route) {
      if (route.settings.name == Routes.TEMPLATES) {
        poppedToTemplates = true;
        return true;
      }
      return false;
    });
    if (!poppedToTemplates) {
      Get.offNamedUntil(Routes.TEMPLATES, (route) => route.isFirst);
    }
  }

  Future<void> exportSavedCardsToPdf() async {
    if (isExportingPdf.value) return;
    if (savedDesigns.isEmpty) {
      Get.snackbar(
        'No saved cards',
        'Save at least one portrait card before exporting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isExportingPdf.value = true;
    try {
      await AppLoadingService.to.run('Preparing print-ready PDF...', () async {
        final result = await CardPdfExportService.buildPortraitPdf(
          savedDesigns.toList(),
        );

        if (result.isEmpty) {
          Get.snackbar(
            'Export failed',
            result.skippedLandscape > 0
                ? 'Only portrait cards are supported for A4 sheets right now.'
                : 'Could not find printable card images on this device.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        await CardPdfExportService.saveToAppExportsDir(result.bytes);
        await CardPdfExportService.sharePdf(result.bytes);

        final skippedParts = <String>[];
        if (result.skippedLandscape > 0) {
          skippedParts.add('${result.skippedLandscape} landscape skipped');
        }
        if (result.skippedMissing > 0) {
          skippedParts.add('${result.skippedMissing} missing image skipped');
        }
        final suffix = skippedParts.isEmpty ? '' : ' (${skippedParts.join(', ')})';

        Get.snackbar(
          'PDF ready',
          '${result.cardCount} card${result.cardCount == 1 ? '' : 's'} on '
          '${result.pageCount} A4 page${result.pageCount == 1 ? '' : 's'}$suffix. '
          'Save or share from the sheet.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      });
    } catch (_) {
      Get.snackbar(
        'Export failed',
        'Could not create PDF. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isExportingPdf.value = false;
    }
  }

  Future<void> deleteSavedDesign(String id) async {
    final index = savedDesigns.indexWhere((d) => d.id == id);
    if (index < 0) return;

    final design = savedDesigns[index];
    for (final path in <String>[
      design.frontImagePath,
      design.backImagePath,
    ]) {
      if (path.isEmpty) continue;
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }

    savedDesigns.removeAt(index);
    await _persistSavedDesigns();
  }

  @override
  void onClose() {
    instituteCtrl.dispose();
    fullNameCtrl.dispose();
    fatherNameCtrl.dispose();
    courseCtrl.dispose();
    sectionCtrl.dispose();
    term1Ctrl.dispose();
    term2Ctrl.dispose();
    term3Ctrl.dispose();
    bloodGroupCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    expiryDateCtrl.dispose();
    validFromCtrl.dispose();
    validToCtrl.dispose();
    idNumberCtrl.dispose();
    departmentCtrl.dispose();
    logoCtrl.dispose();
    signatureCtrl.dispose();
    signatureDrawController.dispose();
    super.onClose();
  }
}
