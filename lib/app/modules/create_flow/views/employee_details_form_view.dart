import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';
import '../widgets/employee_form_assets.dart';
import '../widgets/student_form_widgets.dart';

class EmployeeDetailsFormView extends GetView<CreateFlowController> {
  const EmployeeDetailsFormView({super.key});

  void _submit() {
    final emailError = controller.validateEmail(controller.emailCtrl.text.trim());
    final phoneError = controller.validatePhone(controller.phoneCtrl.text.trim());
    if (emailError != null) {
      Get.snackbar('Invalid Email', emailError);
      return;
    }
    if (phoneError != null) {
      Get.snackbar('Invalid Phone', phoneError);
      return;
    }
    Get.toNamed<void>(Routes.TEMPLATES);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FA),
      appBar: StudentFormHeader(badgeAsset: EmployeeFormAssets.headerBadge),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14, 12, 14, bottom + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StudentFormCard(
                child: Column(
                  children: [
                    StudentSectionHeader(
                      title: 'Basic Information',
                      iconAsset: EmployeeFormAssets.basicInfoHeader,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: StudentPhotoPicker(
                        photoPath: controller.photoPath.value,
                        onAddPhoto: () => controller.showPhotoSourcePicker(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.company,
                      hint: 'Write Company name',
                      controller: controller.instituteCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.yourName,
                      hint: 'Write Your Name',
                      controller: controller.fullNameCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.jobPosition,
                      hint: 'Write Job Position',
                      controller: controller.courseCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.idNumber,
                      hint: 'Write Id number',
                      controller: controller.idNumberCtrl,
                    ),
                    EmployeeJoinDateField(controller: controller.expiryDateCtrl),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.idNumber,
                      hint: 'Write Expire date',
                      controller: controller.validToCtrl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              StudentFormCard(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Column(
                  children: [
                    StudentPhoneField(
                      hint: 'Write Phone Number',
                      controller: controller.phoneCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: EmployeeFormAssets.blood,
                      hint: 'Write Blood Group',
                      controller: controller.bloodGroupCtrl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              StudentFormCard(
                child: Column(
                  children: [
                    StudentSectionHeader(
                      title: 'Optional Items',
                      iconAsset: EmployeeFormAssets.optionalHeader,
                    ),
                    const SizedBox(height: 8),
                    StudentTermField(
                      hint: 'Write Term 1',
                      controller: controller.term1Ctrl,
                      tint: const Color(0xFF8B5CF6),
                    ),
                    StudentTermField(
                      hint: 'Write Term 2',
                      controller: controller.term2Ctrl,
                      tint: const Color(0xFF14B8A6),
                    ),
                    StudentTermField(
                      hint: 'Write Term 3',
                      controller: controller.term3Ctrl,
                      tint: const Color(0xFFEC4899),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const StudentSignatureSection(),
              const SizedBox(height: 20),
              StudentSubmitButton(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
