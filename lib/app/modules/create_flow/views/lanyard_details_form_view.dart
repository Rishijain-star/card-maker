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
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Text & Logo Repeats on Lanyard',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Row(
                        children: [2, 3, 4, 5].map((count) {
                          final isSelected =
                              controller.lanyardRepeatCount.value == count;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.setLanyardRepeatCount(count),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Text(
                                  '${count}x',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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
