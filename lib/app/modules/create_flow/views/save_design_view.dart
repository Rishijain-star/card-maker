import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../routes/app_pages.dart';
import '../controllers/create_flow_controller.dart';

class SaveDesignView extends GetView<CreateFlowController> {
  const SaveDesignView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Save Design', style: AppTextStyles.heading(context, size: 28)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Save requires login. You can preview templates without login.',
              style: AppTextStyles.body(context),
            ),
            const Spacer(),
            GradientButton(
              label: 'Login to Save',
              onPressed: () => Get.toNamed<void>(Routes.SAVE_AUTH),
            ),
          ],
        ),
      ),
    );
  }
}
