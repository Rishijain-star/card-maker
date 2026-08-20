import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/employee_data.dart';
import '../../../data/models/lanyard_data.dart';
import '../../../data/models/student_data.dart';
import '../../../routes/app_pages.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_theme.dart';
import '../widgets/student_id_card_view.dart';

/// `colors` = body text colour, `headerColors` = the institute/company title.
enum TemplateEditorPanel { none, fonts, colors, headerColors, logos, position }

/// Coordinates template selection, live card data, and export capture keys.
class TemplateController extends GetxController {
  final GlobalKey frontExportKey = GlobalKey();
  final GlobalKey backExportKey = GlobalKey();

  final Rx<StudentData> studentData = StudentData.empty.obs;
  final Rx<EmployeeData> employeeData = EmployeeData.empty.obs;
  final Rx<LanyardData> lanyardData = LanyardData.empty.obs;
  final RxInt selectedTemplateIndex = 0.obs;
  final Rx<TemplateEditorPanel> activePanel = TemplateEditorPanel.none.obs;
  final RxBool showFontSizeControls = false.obs;

  void toggleFontSizeControls() {
    showFontSizeControls.value = !showFontSizeControls.value;
  }

  CreateFlowController get _flow => Get.find<CreateFlowController>();

  final List<TextEditingController> _boundControllers = <TextEditingController>[];

  @override
  void onInit() {
    super.onInit();
    selectedTemplateIndex.value = _flow.selectedTemplate.value;
    _bindFormListeners();
    refreshCardData();
  }

  bool get isEmployeeService => _flow.isEmployeeService;

  bool get isLanyardService => _flow.isLanyardService;

  void _bindFormListeners() {
    final controllers = <TextEditingController>[
      _flow.instituteCtrl,
      _flow.fullNameCtrl,
      _flow.fatherNameCtrl,
      _flow.courseCtrl,
      _flow.sectionCtrl,
      _flow.idNumberCtrl,
      _flow.validFromCtrl,
      _flow.validToCtrl,
      _flow.expiryDateCtrl,
      _flow.departmentCtrl,
      _flow.phoneCtrl,
      _flow.emailCtrl,
      _flow.addressCtrl,
      _flow.bloodGroupCtrl,
      _flow.term1Ctrl,
      _flow.term2Ctrl,
      _flow.term3Ctrl,
    ];
    for (final c in controllers) {
      c.addListener(refreshCardData);
      _boundControllers.add(c);
    }
    ever(_flow.photoPath, (_) => refreshCardData());
    ever(_flow.signaturePath, (_) => refreshCardData());
    ever(_flow.signatureImageBytes, (_) => refreshCardData());
    ever(_flow.selectedService, (_) => refreshCardData());
    ever(_flow.selectedCompanyLogo, (_) => refreshCardData());
    ever(_flow.selectedColor, (_) => refreshCardData());
    ever(_flow.lanyardRepeatCount, (_) => refreshCardData());
    ever(_flow.lanyardTextOffsetX, (_) => refreshCardData());
    ever(_flow.lanyardTextOffsetY, (_) => refreshCardData());
    ever(_flow.lanyardLogoTextSpacing, (_) => refreshCardData());
    ever(_flow.lanyardCustomTextColorHex, (_) => refreshCardData());
  }

  void selectCompanyLogo(int pickerIndex) {
    _flow.updateCurrentTemplateSettings(
        companyLogoIndex: pickerIndex.clamp(0, _flow.companyLogoOptions.length));
  }

  void selectFont(int index) {
    _flow.updateCurrentTemplateSettings(
        fontIndex: index.clamp(0, _flow.fonts.length - 1));
  }

  void selectColor(int index) {
    _flow.updateCurrentTemplateSettings(
        colorIndex: index.clamp(0, _flow.palette.length - 1));
  }

  void refreshCardData() {
    if (isLanyardService) {
      lanyardData.value = LanyardData.fromCreateFlow(_flow);
    } else if (isEmployeeService) {
      employeeData.value = EmployeeData.fromCreateFlow(_flow);
    } else {
      studentData.value = StudentData.fromCreateFlow(_flow);
    }
    _flow.update(<Object>[
      'template_screen',
      'student_preview',
      'employee_preview',
      'lanyard_preview',
      'live_preview',
    ]);
  }

  void refreshStudentData() => refreshCardData();

  void selectTemplate(int globalIndex) {
    selectedTemplateIndex.value = globalIndex;
    _flow.setSelectedTemplate(globalIndex);
    refreshCardData();
  }

  void openTemplateEditor(int globalIndex) {
    selectTemplate(globalIndex);
    activePanel.value = TemplateEditorPanel.none;
    Get.toNamed<void>(Routes.TEMPLATE_PREVIEW);
  }

  void togglePanel(TemplateEditorPanel panel) {
    activePanel.value = activePanel.value == panel ? TemplateEditorPanel.none : panel;
  }

  String get currentFontFamily => _flow.selectedFontFamily;

  IdCardTheme themeForTemplate(int globalIndex) {
    if (isEmployeeService) {
      return IdCardTheme.template03Purple;
    }
    if (isStudentIdTemplateEngine(globalIndex)) {
      return IdCardTheme.forStudentTemplateIndex(globalIndex);
    }
    return IdCardTheme.template01Blue;
  }

  bool usesStudentTemplate01(int globalIndex) =>
      !isEmployeeService && isStudentIdTemplateEngine(globalIndex);

  double get exportPixelRatio => IdCardDimensions.exportPixelRatio;

  @override
  void onClose() {
    for (final c in _boundControllers) {
      c.removeListener(refreshCardData);
    }
    super.onClose();
  }
}
