import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_flow_controller.dart';
import '../widgets/student_form_assets.dart';
import '../widgets/student_form_widgets.dart';

class LanyardDetailsFormView extends GetView<CreateFlowController> {
  const LanyardDetailsFormView({super.key});

  void _submit() {
    controller.navigateAfterFormSubmit();
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
                      title: 'Lanyard Setup',
                      iconAsset: StudentFormAssets.basicInfoHeader,
                    ),
                    const SizedBox(height: 20),
                    // 1. Logo Upload Option
                    Center(
                      child: StudentPhotoPicker(
                        photoPath: controller.photoPath.value,
                        onAddPhoto: () => controller.showPhotoSourcePicker(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload Lanyard Logo (Optional)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // 2. Single Lanyard Text Field
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.university,
                      hint: 'Enter Lanyard Text (e.g. CITY PUBLIC SCHOOL)',
                      controller: controller.instituteCtrl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StudentSubmitButton(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
