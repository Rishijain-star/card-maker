import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';

class LiveCustomizationView extends GetView<CreateFlowController> {
  const LiveCustomizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Live Customization', style: AppTextStyles.heading(context, size: 28)),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Obx(
                () => AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: controller.palette[controller.selectedColor.value], width: 1.2),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.fullNameCtrl.text.isEmpty
                            ? 'Your Name'
                            : controller.fullNameCtrl.text,
                        style: AppTextStyles.heading(context, size: 24).copyWith(
                          color: controller.palette[controller.selectedColor.value],
                          fontFamily: controller.fonts[controller.selectedFont.value],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        controller.departmentCtrl.text.isEmpty
                            ? 'Department'
                            : controller.departmentCtrl.text,
                        style: AppTextStyles.body(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Logo: ${controller.logoCtrl.text}',
                        style: AppTextStyles.body(context),
                      ),
                      Text(
                        'Signature: ${controller.signaturePath.value.isEmpty ? "Pending" : "Ready"}',
                        style: AppTextStyles.body(context),
                      ),
                      const Spacer(),
                      Text(
                        controller.selectedService.value,
                        style: AppTextStyles.body(context, size: 16).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _ToolChip(
                    label: 'Fonts',
                    onTap: () {
                      final nextIndex = (controller.selectedFont.value + 1) % controller.fonts.length;
                      controller.updateCurrentTemplateSettings(fontIndex: nextIndex);
                    },
                  ),
                  _ToolChip(
                    label: 'Logos',
                    onTap: () => AppBottomSheet.show<void>(
                      context,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextField(
                            hintText: 'Logo text',
                            controller: controller.logoCtrl,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          GradientButton(
                            label: 'Apply',
                            onPressed: () => Get.back<void>(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ToolChip(
                    label: 'Colors',
                    onTap: () {
                      controller.selectedColor.value =
                          (controller.selectedColor.value + 1) % controller.palette.length;
                    },
                  ),
                  _ToolChip(
                    label: 'Photo',
                    onTap: controller.pickFromGallery,
                  ),
                  _ToolChip(
                    label: 'Signature',
                    onTap: controller.pickSignatureFromGallery,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const SizedBox(height: AppSpacing.sm),
            GradientButton(
              label: 'Live Preview',
              onPressed: () => Get.toNamed<void>(Routes.LIVE_PREVIEW),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppGradients.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.button(context).copyWith(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
