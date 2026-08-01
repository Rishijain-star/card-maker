import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';
import '../widgets/student_form_assets.dart';
import '../widgets/student_form_widgets.dart';

class StudentDetailsFormView extends GetView<CreateFlowController> {
  const StudentDetailsFormView({super.key});

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
      appBar: StudentFormHeader(badgeAsset: StudentFormAssets.headerBadge),
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
                      iconAsset: StudentFormAssets.basicInfoHeader,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: StudentPhotoPicker(
                        photoPath: controller.photoPath.value,
                        onAddPhoto: controller.pickFromCamera,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.university,
                      hint: 'Write Institute name',
                      controller: controller.instituteCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.student,
                      hint: 'Write Student Name',
                      controller: controller.fullNameCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.father,
                      hint: 'Write Father Name',
                      controller: controller.fatherNameCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.book,
                      hint: 'Write Course / Class',
                      controller: controller.courseCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.book,
                      hint: 'Write Section',
                      controller: controller.sectionCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.registration,
                      hint: 'Write Roll Number',
                      controller: controller.idNumberCtrl,
                    ),
                    StudentValidityDateRow(
                      validFromCtrl: controller.validFromCtrl,
                      validToCtrl: controller.validToCtrl,
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
                      iconAsset: StudentFormAssets.email,
                      hint: 'Write Email Address',
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.blood,
                      hint: 'Write Blood Group',
                      controller: controller.bloodGroupCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.university,
                      hint: 'Write Address',
                      controller: controller.addressCtrl,
                    ),
                  ],
                ),
              ),
              StudentFormCard(
                child: Column(
                  children: [
                    StudentSectionHeader(
                      title: 'Optional Items',
                      iconAsset: StudentFormAssets.optionalHeader,
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
              StudentSignatureSection(
                hasSignature: controller.signaturePath.value.isNotEmpty ||
                    (controller.signatureImageBytes.value?.isNotEmpty ?? false),
                onCapture: controller.pickSignatureFromCamera,
                onPickFromGallery: controller.pickSignatureFromGallery,
              ),
              const SizedBox(height: 20),
              StudentSubmitButton(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
