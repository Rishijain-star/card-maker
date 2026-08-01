import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../../routes/app_pages.dart';

class SaveSuccessView extends StatelessWidget {
  const SaveSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 88),
            const SizedBox(height: AppSpacing.md),
            Text('Design Saved', style: AppTextStyles.heading(context, size: 30)),
            const SizedBox(height: AppSpacing.sm),
            Text('Your design is available in My Designs.', style: AppTextStyles.body(context)),
            const Spacer(),
            GradientButton(
              label: 'Go to My Designs',
              onPressed: () => Get.offAllNamed<void>(Routes.MY_DESIGNS),
            ),
          ],
        ),
      ),
    );
  }
}
