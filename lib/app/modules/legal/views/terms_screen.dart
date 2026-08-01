import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppToolbar(title: 'Terms & Conditions', onBack: () => Navigator.of(context).pop()),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Terms content placeholder.\n\nThis page will be updated with full legal content.',
                  style: AppTextStyles.body(context, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
