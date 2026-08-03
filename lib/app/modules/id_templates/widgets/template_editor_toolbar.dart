import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../controllers/template_controller.dart';
import 'id_card_font_picker.dart';

/// Template editor — Font only; tap to expand horizontal font list on same screen.
class TemplateEditorToolbar extends GetView<TemplateController> {
  const TemplateEditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();

    return Obx(
      () {
        final panel = controller.activePanel.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (panel == TemplateEditorPanel.fonts) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.font_download_outlined, size: 16, color: Color(0xFF2563EB)),
                        const SizedBox(width: 5),
                        Text(
                          flow.selectedFontFamily,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Text(
                        'Font Size: ${(flow.fontSizeScale.value * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: flow.decrementFontSizeScale,
                      icon: const Icon(Icons.remove_circle, size: 22, color: Color(0xFF2563EB)),
                      tooltip: 'Decrease font size',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                          activeTrackColor: const Color(0xFF2563EB),
                          inactiveTrackColor: const Color(0xFFE2E8F0),
                          thumbColor: const Color(0xFF2563EB),
                        ),
                        child: Slider(
                          value: flow.fontSizeScale.value,
                          min: 0.70,
                          max: 1.50,
                          divisions: 16,
                          onChanged: flow.setFontSizeScale,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: flow.incrementFontSizeScale,
                      icon: const Icon(Icons.add_circle, size: 22, color: Color(0xFF2563EB)),
                      tooltip: 'Increase font size',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                    if (flow.fontSizeScale.value != 1.0)
                      IconButton(
                        onPressed: flow.resetFontSizeScale,
                        icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF64748B)),
                        tooltip: 'Reset size to 100%',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(left: 4),
                      ),
                  ],
                ),
              ),
              IdCardFontPicker(
                fonts: flow.fonts,
                selectedIndex: flow.selectedFont.value,
                layout: IdCardFontPickerLayout.strip,
                onSelect: controller.selectFont,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (panel == TemplateEditorPanel.position && flow.isLanyardService) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.open_with_rounded, size: 16, color: Color(0xFF2563EB)),
                        SizedBox(width: 5),
                        Text(
                          'Adjust Position',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: flow.resetLanyardTextOffset,
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF64748B)),
                      tooltip: 'Reset position',
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('X:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: flow.lanyardTextOffsetX.value,
                            min: -100.0,
                            max: 100.0,
                            onChanged: flow.setLanyardTextOffsetX,
                          ),
                        ),
                        Text('${flow.lanyardTextOffsetX.value.round()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Y:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: flow.lanyardTextOffsetY.value,
                            min: -20.0,
                            max: 20.0,
                            onChanged: flow.setLanyardTextOffsetY,
                          ),
                        ),
                        Text('${flow.lanyardTextOffsetY.value.round()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Gap:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: flow.lanyardLogoTextSpacing.value,
                            min: 0.0,
                            max: 40.0,
                            onChanged: flow.setLanyardLogoTextSpacing,
                          ),
                        ),
                        Text('${flow.lanyardLogoTextSpacing.value.round()}px', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (panel == TemplateEditorPanel.colors) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.palette_rounded, size: 16, color: Color(0xFF2563EB)),
                        SizedBox(width: 5),
                        Text(
                          'Text Color',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    if (flow.isLanyardService)
                      TextButton(
                        onPressed: () => flow.setLanyardTextColorHex(null),
                        child: const Text('Reset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Color(0xFFFFFFFF),
                      const Color(0xFFFFD700),
                      const Color(0xFF00E5FF),
                      const Color(0xFFFF4757),
                      const Color(0xFF2ED573),
                      const Color(0xFFFFA500),
                      const Color(0xFFA855F7),
                      const Color(0xFF0F172A),
                      const Color(0xFF2563EB),
                    ].map((color) {
                      final isSelected = flow.isLanyardService
                          ? flow.lanyardCustomTextColorHex.value == color.toARGB32()
                          : false;

                      return GestureDetector(
                        onTap: () {
                          if (flow.isLanyardService) {
                            flow.setLanyardTextColorHex(color.toARGB32());
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : (color == Colors.white ? const Color(0xFFCBD5E1) : Colors.transparent),
                              width: isSelected ? 3.0 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ToolChip(
                    label: 'Stylish Font',
                    icon: Icons.font_download_rounded,
                    active: panel == TemplateEditorPanel.fonts,
                    onTap: () => controller.togglePanel(TemplateEditorPanel.fonts),
                  ),
                  if (flow.isLanyardService) ...[
                    const SizedBox(width: 10),
                    _ToolChip(
                      label: 'Font Color',
                      icon: Icons.palette_rounded,
                      active: panel == TemplateEditorPanel.colors,
                      onTap: () => controller.togglePanel(TemplateEditorPanel.colors),
                    ),
                    const SizedBox(width: 10),
                    _ToolChip(
                      label: 'Adjust Position',
                      icon: Icons.open_with_rounded,
                      active: panel == TemplateEditorPanel.position,
                      onTap: () => controller.togglePanel(TemplateEditorPanel.position),
                    ),
                    const SizedBox(width: 10),
                    _ToolChip(
                      label: 'Change Logo',
                      icon: Icons.add_photo_alternate_rounded,
                      active: false,
                      onTap: () => flow.showPhotoSourcePicker(context),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => _ToolChip(
                        label: 'Repeats: ${flow.lanyardRepeatCount.value}x',
                        icon: Icons.repeat_rounded,
                        active: false,
                        onTap: () {
                          final current = flow.lanyardRepeatCount.value;
                          final next = current >= 5 ? 2 : current + 1;
                          flow.setLanyardRepeatCount(next);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.label,
    required this.onTap,
    this.icon,
    this.active = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
          decoration: BoxDecoration(
            gradient: active ? AppGradients.primary : AppGradients.secondary,
            borderRadius: BorderRadius.circular(20),
            border: active
                ? Border.all(color: const Color(0xFF2563EB), width: 2)
                : Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: active ? Colors.white : const Color(0xFF2563EB),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
