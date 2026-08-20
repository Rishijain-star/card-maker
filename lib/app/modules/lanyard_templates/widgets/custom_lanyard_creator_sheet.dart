import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/lanyard_data.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_design_system_widgets.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../../create_flow/widgets/student_form_assets.dart';
import '../../create_flow/widgets/student_form_widgets.dart';
import 'lanyard_scaled_preview.dart';
import 'lanyard_template_selector.dart';

class CustomLanyardCreatorSheet extends GetView<CreateFlowController> {
  const CustomLanyardCreatorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomLanyardCreatorSheet(),
    );
  }

  static const List<Map<String, dynamic>> presetRibbonColors = [
    {'name': 'Royal Navy', 'color': Color(0xFF1E3A8A)},
    {'name': 'Jet Black', 'color': Color(0xFF0F172A)},
    {'name': 'Crimson Red', 'color': Color(0xFFB71C1C)},
    {'name': 'Emerald Green', 'color': Color(0xFF15803D)},
    {'name': 'Deep Purple', 'color': Color(0xFF581C87)},
    {'name': 'Amber Gold', 'color': Color(0xFFD97706)},
    {'name': 'Cyan Blue', 'color': Color(0xFF0284C7)},
    {'name': 'Teal Green', 'color': Color(0xFF0F766E)},
    {'name': 'Maroon Red', 'color': Color(0xFF881337)},
    {'name': 'Pure White', 'color': Color(0xFFFFFFFF)},
    {'name': 'Vibrant Orange', 'color': Color(0xFFEA580C)},
  ];

  static const List<Map<String, dynamic>> presetTextColors = [
    {'name': 'White', 'color': Colors.white},
    {'name': 'Gold', 'color': Color(0xFFFFD700)},
    {'name': 'Yellow', 'color': Color(0xFFFACC15)},
    {'name': 'Black', 'color': Color(0xFF0F172A)},
    {'name': 'Silver', 'color': Color(0xFFE2E8F0)},
    {'name': 'Cyan', 'color': Color(0xFF38BDF8)},
    {'name': 'Red', 'color': Color(0xFFEF4444)},
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height * 0.88;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🎨 ', style: TextStyle(fontSize: 20)),
                    Text(
                      'Create Your Own Lanyard',
                      style: AppTextStyles.heading(context, size: 20),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                mediaQuery.padding.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Live Scaled Lanyard Preview
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'LIVE LANYARD PREVIEW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          // Listen to reactive states
                          controller.photoPath.value;
                          controller.instituteCtrl.text;
                          controller.lanyardCustomRibbonColorHex.value;
                          controller.lanyardCustomTextColorHex.value;

                          final data = LanyardData.fromCreateFlow(controller);
                          return LanyardScaledPreview(
                            child: buildLanyardTemplate(
                              variant: 99,
                              data: data,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 1. Ribbon Text Input
                  StudentFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StudentSectionHeader(
                          title: 'Lanyard Text / Name',
                          iconAsset: StudentFormAssets.basicInfoHeader,
                        ),
                        const SizedBox(height: 16),
                        StudentUnderlineField(
                          iconAsset: StudentFormAssets.university,
                          hint: 'e.g. CITY PUBLIC SCHOOL',
                          controller: controller.instituteCtrl,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Ribbon Background Color Picker
                  StudentFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.palette_outlined, color: Color(0xFF2563EB), size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Ribbon Background Color',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Obx(() {
                          final currentHex = controller.lanyardCustomRibbonColorHex.value;
                          final currentColor = Color(currentHex);

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // Full Color Picker Button (Custom Color Wheel)
                              GestureDetector(
                                onTap: () {
                                  _LanyardColorPickerDialog.show(
                                    context,
                                    initialColor: currentColor,
                                    onColorChanged: (c) {
                                      controller.setCustomRibbonColorHex(c.toARGB32());
                                    },
                                    title: 'Pick Ribbon Background Color',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFEC4899),
                                        Color(0xFF8B5CF6),
                                        Color(0xFF3B82F6),
                                        Color(0xFF10B981),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.colorize_rounded, color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Custom Color Picker 🎨',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ...presetRibbonColors.map((item) {
                                final color = item['color'] as Color;
                                final hex = color.toARGB32();
                                final isSelected = currentHex == hex;

                                return GestureDetector(
                                  onTap: () => controller.setCustomRibbonColorHex(hex),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
                                        width: isSelected ? 3.5 : 1.5,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 22,
                                            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                          )
                                        : null,
                                  ),
                                );
                              }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Text Color Picker
                  StudentFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.format_color_text, color: Color(0xFF7C3AED), size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Text Color',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Obx(() {
                          final currentHex = controller.lanyardCustomTextColorHex.value;
                          final currentColor = currentHex != null ? Color(currentHex) : Colors.white;

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // Full Color Picker Button for Text Color
                              GestureDetector(
                                onTap: () {
                                  _LanyardColorPickerDialog.show(
                                    context,
                                    initialColor: currentColor,
                                    onColorChanged: (c) {
                                      controller.setLanyardTextColorHex(c.toARGB32());
                                    },
                                    title: 'Pick Lanyard Text Color',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFF59E0B),
                                        Color(0xFFEF4444),
                                        Color(0xFF8B5CF6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.palette_rounded, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Custom Text Color 🎨',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Default option
                              GestureDetector(
                                onTap: () => controller.setLanyardTextColorHex(null),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: currentHex == null ? Colors.blueGrey.shade800 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: currentHex == null ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              ...presetTextColors.map((item) {
                                final color = item['color'] as Color;
                                final hex = color.toARGB32();
                                final isSelected = currentHex == hex;

                                return GestureDetector(
                                  onTap: () => controller.setLanyardTextColorHex(hex),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.shade300,
                                        width: isSelected ? 3 : 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 18,
                                            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                          )
                                        : null,
                                  ),
                                );
                              }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. Logo Upload Option
                  StudentFormCard(
                    child: Column(
                      children: [
                        StudentSectionHeader(
                          title: 'Lanyard Logo',
                          iconAsset: StudentFormAssets.basicInfoHeader,
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: StudentPhotoPicker(
                            photoPath: controller.photoPath.value,
                            onAddPhoto: () => controller.showPhotoSourcePicker(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Custom Logo (Optional)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Action Button
                  GradientButton(
                    label: 'Use This Custom Lanyard',
                    onPressed: () {
                      controller.isCustomLanyard.value = true;
                      controller.selectedTemplate.value = 0;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanyardColorPickerDialog extends StatefulWidget {
  const _LanyardColorPickerDialog({
    required this.initialColor,
    required this.onColorChanged,
    required this.title,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final String title;

  static Future<Color?> show(
    BuildContext context, {
    required Color initialColor,
    required ValueChanged<Color> onColorChanged,
    required String title,
  }) {
    return showDialog<Color>(
      context: context,
      builder: (context) => _LanyardColorPickerDialog(
        initialColor: initialColor,
        onColorChanged: onColorChanged,
        title: title,
      ),
    );
  }

  @override
  State<_LanyardColorPickerDialog> createState() => _LanyardColorPickerDialogState();
}

class _LanyardColorPickerDialogState extends State<_LanyardColorPickerDialog> {
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initialColor);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value == 0 ? 1.0 : hsv.value;
  }

  Color get _currentColor => HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();

  void _notifyColor() {
    widget.onColorChanged(_currentColor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _currentColor;
    final hexString = '#${currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(_currentColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Color Preview Circle & Hex Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: currentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: currentColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SELECTED COLOR',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hexString,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Hue Slider (Rainbow Gradient)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hue (Color Wheel)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF0000),
                          Color(0xFFFFFF00),
                          Color(0xFF00FF00),
                          Color(0xFF00FFFF),
                          Color(0xFF0000FF),
                          Color(0xFFFF00FF),
                          Color(0xFFFF0000),
                        ],
                      ),
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: const RectangularSliderTrackShape(),
                        trackHeight: 24,
                        thumbColor: Colors.white,
                        overlayColor: Colors.transparent,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                      ),
                      child: Slider(
                        value: _hue,
                        min: 0.0,
                        max: 360.0,
                        onChanged: (val) {
                          _hue = val;
                          _notifyColor();
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Saturation Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saturation (Color Intensity)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: currentColor,
                      activeTrackColor: currentColor,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                    child: Slider(
                      value: _saturation,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (val) {
                        _saturation = val;
                        _notifyColor();
                      },
                    ),
                  ),
                ],
              ),

              // Brightness / Value Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Brightness', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: currentColor,
                      activeTrackColor: currentColor,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                    child: Slider(
                      value: _value,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (val) {
                        _value = val;
                        _notifyColor();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Quick Swatches Grid (20 Popular ID Card Ribbon Colors)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Popular Color Swatches', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF0F172A),
                  const Color(0xFFB71C1C),
                  const Color(0xFF15803D),
                  const Color(0xFF581C87),
                  const Color(0xFFD97706),
                  const Color(0xFF0284C7),
                  const Color(0xFF0F766E),
                  const Color(0xFF881337),
                  const Color(0xFFFFFFFF),
                  const Color(0xFFEA580C),
                  const Color(0xFF2563EB),
                  const Color(0xFF9333EA),
                  const Color(0xFFDC2626),
                  const Color(0xFF16A34A),
                  const Color(0xFFCA8A04),
                  const Color(0xFF06B6D4),
                  const Color(0xFFE11D48),
                  const Color(0xFF475569),
                  const Color(0xFF000000),
                ].map((swatchColor) {
                  final isSelected = (swatchColor.toARGB32() == currentColor.toARGB32());
                  return GestureDetector(
                    onTap: () {
                      final hsv = HSVColor.fromColor(swatchColor);
                      _hue = hsv.hue;
                      _saturation = hsv.saturation;
                      _value = hsv.value == 0 ? 1.0 : hsv.value;
                      _notifyColor();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: swatchColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: swatchColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Done / Apply Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(_currentColor),
                  child: const Text(
                    'Apply Color',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
