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
                      title: 'Lanyard Details',
                      iconAsset: StudentFormAssets.basicInfoHeader,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: StudentPhotoPicker(
                        photoPath: controller.photoPath.value,
                        onAddPhoto: controller.pickFromGallery,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add logo (optional)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.university,
                      hint: 'Organization / School name',
                      controller: controller.instituteCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.student,
                      hint: 'Name on lanyard',
                      controller: controller.fullNameCtrl,
                    ),
                    StudentUnderlineField(
                      iconAsset: StudentFormAssets.book,
                      hint: 'Role / Title (e.g. STAFF, STUDENT)',
                      controller: controller.courseCtrl,
                    ),
                  ],
                ),
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
