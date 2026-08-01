import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/dd_mm_yyyy_input_formatter.dart';
import '../../id_templates/controllers/template_controller.dart';
import '../controllers/create_flow_controller.dart';

const Color _kFormBlue = Color(0xFF1E88E5);
const Color _kUnderline = Color(0xFFB3D4F5);
const Color _kHint = Color(0xFF64748B);

const List<Color> _kRainbowRingColors = [
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
  Color(0xFFF97316),
  Color(0xFFEAB308),
  Color(0xFF22C55E),
];

class StudentFormHeader extends StatelessWidget implements PreferredSizeWidget {
  const StudentFormHeader({super.key, required this.badgeAsset});

  final String badgeAsset;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _kFormBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      centerTitle: true,
      title: Text(
        'Fill All Items',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Image.asset(badgeAsset, width: 30, height: 30, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class StudentSectionHeader extends StatelessWidget {
  const StudentSectionHeader({
    super.key,
    required this.title,
    required this.iconAsset,
  });

  final String title;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Expanded(child: _RainbowLine()),
          const SizedBox(width: 8),
          Image.asset(iconAsset, width: 22, height: 22, fit: BoxFit.contain),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: _kFormBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: _RainbowLine()),
        ],
      ),
    );
  }
}

class _RainbowLine extends StatelessWidget {
  const _RainbowLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFF97316),
            Color(0xFFEAB308),
            Color(0xFF22C55E),
            Color(0xFF3B82F6),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
    );
  }
}

class StudentFormCard extends StatelessWidget {
  const StudentFormCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class StudentPhotoPicker extends StatelessWidget {
  const StudentPhotoPicker({
    super.key,
    required this.photoPath,
    required this.onAddPhoto,
  });

  final String photoPath;
  final VoidCallback onAddPhoto;

  static const double _outerSize = 132;
  static const double _ringWidth = 3.5;
  static const double _plusSize = 34;

  @override
  Widget build(BuildContext context) {
    // Plus sits on the bottom centre of the rainbow stroke.
    final plusBottom = -(_plusSize / 2) + (_ringWidth / 2);

    return Padding(
      padding: EdgeInsets.only(bottom: _plusSize / 2),
      child: SizedBox(
        width: _outerSize,
        height: _outerSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: _outerSize,
              height: _outerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(colors: _kRainbowRingColors),
              ),
              child: Padding(
                padding: const EdgeInsets.all(_ringWidth),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onAddPhoto,
                      child: photoPath.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 36,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Click Photo',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: _kHint,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : ClipOval(
                              child: Image.file(
                                File(photoPath),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: plusBottom,
              child: Center(
                child: GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    width: _plusSize,
                    height: _plusSize,
                    decoration: BoxDecoration(
                      color: _kFormBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentUnderlineField extends StatelessWidget {
  const StudentUnderlineField({
    super.key,
    this.iconAsset,
    required this.hint,
    required this.controller,
    this.iconSize = 28,
    this.iconWidget,
    this.keyboardType,
    this.maxLines,
    this.minLines = 1,
    this.textInputAction,
  }) : assert(iconAsset != null || iconWidget != null);

  final String? iconAsset;
  final Widget? iconWidget;
  final String hint;
  final TextEditingController controller;
  final double iconSize;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;

  static const InputDecoration _fieldDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    final isSpecialKey = keyboardType == TextInputType.phone ||
        keyboardType == TextInputType.number ||
        keyboardType == TextInputType.emailAddress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: Center(
              child: iconWidget ??
                  (iconAsset != null
                      ? Image.asset(
                          iconAsset!,
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox.shrink()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: keyboardType ??
                      (isSpecialKey ? keyboardType : TextInputType.multiline),
                  minLines: minLines,
                  maxLines: maxLines ?? (isSpecialKey ? 1 : null),
                  textInputAction: textInputAction ??
                      (isSpecialKey
                          ? TextInputAction.next
                          : TextInputAction.newline),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _fieldDecoration.copyWith(
                    hintText: hint,
                    filled: false,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF94A3B8)
                          : _kHint,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1.2, color: _kUnderline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentPhoneField extends StatelessWidget {
  const StudentPhoneField({
    super.key,
    required this.hint,
    required this.controller,
  });

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return StudentUnderlineField(
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.phone,
      iconWidget: Icon(Icons.phone_in_talk_rounded, color: Colors.green.shade600, size: 26),
    );
  }
}

class StudentTermField extends StatelessWidget {
  const StudentTermField({
    super.key,
    required this.hint,
    required this.controller,
    required this.tint,
  });

  final String hint;
  final TextEditingController controller;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return StudentUnderlineField(
      hint: hint,
      controller: controller,
      iconWidget: Icon(Icons.calendar_month_rounded, color: tint, size: 26),
    );
  }
}

/// Card validity — Valid From (left) and Valid To (right), tap to pick dates.
class StudentValidityDateRow extends StatelessWidget {
  const StudentValidityDateRow({
    super.key,
    required this.validFromCtrl,
    required this.validToCtrl,
  });

  final TextEditingController validFromCtrl;
  final TextEditingController validToCtrl;

  Future<void> _pickDate(
    BuildContext context, {
    required TextEditingController controller,
    required DateTime? firstDate,
    required DateTime lastDate,
  }) async {
    final now = DateTime.now();
    final parsed = DdMmYyyyDash.parse(controller.text);
    var initial = parsed ?? now;
    if (firstDate != null && initial.isBefore(firstDate)) {
      initial = firstDate;
    }
    if (initial.isAfter(lastDate)) {
      initial = lastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(1990),
      lastDate: lastDate,
      helpText: 'Select date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _kFormBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DdMmYyyyDash.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ValidityDateCell(
              label: 'Valid From',
              controller: validFromCtrl,
              iconColor: _kFormBlue,
              onTap: () => _pickDate(
                context,
                controller: validFromCtrl,
                firstDate: DateTime(1990),
                lastDate: DateTime(2100),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _ValidityDateCell(
              label: 'Valid To',
              controller: validToCtrl,
              iconColor: const Color(0xFF14B8A6),
              onTap: () {
                final from = DdMmYyyyDash.parse(validFromCtrl.text);
                _pickDate(
                  context,
                  controller: validToCtrl,
                  firstDate: from ?? DateTime(1990),
                  lastDate: DateTime(2100),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidityDateCell extends StatelessWidget {
  const _ValidityDateCell({
    required this.label,
    required this.controller,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_rounded, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      final hasText = value.text.isNotEmpty;
                      return TextField(
                        controller: controller,
                        readOnly: true,
                        onTap: onTap,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: StudentUnderlineField._fieldDecoration.copyWith(
                          hintText: label,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF94A3B8)
                                : _kHint,
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: hasText
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                  },
                                  tooltip: 'Clear date',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, thickness: 1.2, color: _kUnderline),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Signature upload — same circle style as photo; no image preview on form.
class StudentSignaturePicker extends StatelessWidget {
  const StudentSignaturePicker({
    super.key,
    required this.hasSignature,
    required this.onAddSignature,
  });

  final bool hasSignature;
  final VoidCallback onAddSignature;

  static const double _outerSize = 120;
  static const double _ringWidth = 3.5;
  static const double _plusSize = 34;

  @override
  Widget build(BuildContext context) {
    final plusBottom = -(_plusSize / 2) + (_ringWidth / 2);

    return Padding(
      padding: EdgeInsets.only(bottom: _plusSize / 2),
      child: SizedBox(
        width: _outerSize,
        height: _outerSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: _outerSize,
              height: _outerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(colors: _kRainbowRingColors),
              ),
              child: Padding(
                padding: const EdgeInsets.all(_ringWidth),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onAddSignature,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasSignature
                                ? Icons.check_circle_rounded
                                : Icons.draw_rounded,
                            size: 34,
                            color: hasSignature
                                ? const Color(0xFF22C55E)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            hasSignature ? 'Added' : 'Add Signature',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: plusBottom,
              child: Center(
                child: GestureDetector(
                  onTap: onAddSignature,
                  child: Container(
                    width: _plusSize,
                    height: _plusSize,
                    decoration: BoxDecoration(
                      color: _kFormBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSignatureSection extends GetView<CreateFlowController> {
  const StudentSignatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentFormCard(
      child: Obx(
        () {
          final hasSig = controller.signaturePath.value.isNotEmpty ||
              (controller.signatureImageBytes.value?.isNotEmpty ?? false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: _RainbowLine()),
                  const SizedBox(width: 8),
                  const Icon(Icons.draw_rounded, color: _kFormBlue, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Signature Image & Outline',
                    style: GoogleFonts.poppins(
                      color: _kFormBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: _RainbowLine()),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 220,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(110, 55),
                        ),
                        border: controller.signatureHasBorder.value
                            ? Border.all(
                                color: controller.currentSignatureBorderColor,
                                width: controller.signatureBorderWidth.value,
                              )
                            : Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: ClipOval(
                        child: _buildSignaturePreview(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: controller.pickSignatureFromCamera,
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Camera'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _kFormBlue,
                            side: const BorderSide(color: _kFormBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: controller.pickSignatureFromGallery,
                          icon: const Icon(Icons.photo_library_outlined, size: 18),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _kFormBlue,
                            side: const BorderSide(color: _kFormBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    if (hasSig) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.cropExistingSignature,
                            icon: const Icon(Icons.crop, size: 18),
                            label: const Text('Crop Signature'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: controller.clearSignature,
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            label: const Text('Clear', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.border_style_rounded, size: 20, color: Color(0xFF334155)),
                      const SizedBox(width: 8),
                      Text(
                        'Signature Outline (Border)',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: controller.signatureHasBorder.value,
                    activeTrackColor: _kFormBlue,
                    onChanged: (val) {
                      controller.signatureHasBorder.value = val;
                      if (Get.isRegistered<TemplateController>()) {
                        Get.find<TemplateController>().refreshCardData();
                      }
                    },
                  ),
                ],
              ),
              if (controller.signatureHasBorder.value) ...[
                const SizedBox(height: 12),
                Text(
                  'Select Border Color:',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    CreateFlowController.signatureBorderColors.length,
                    (index) {
                      final c = CreateFlowController.signatureBorderColors[index];
                      final isSelected = controller.signatureBorderColorIndex.value == index;
                      return GestureDetector(
                        onTap: () {
                          controller.signatureBorderColorIndex.value = index;
                          if (Get.isRegistered<TemplateController>()) {
                            Get.find<TemplateController>().refreshCardData();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? _kFormBlue : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: c == Colors.white ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Border Thickness (Pixels):',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [1.0, 2.0, 3.0, 4.0].map((w) {
                    final isSelected = controller.signatureBorderWidth.value == w;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('${w.toInt()}px'),
                        selected: isSelected,
                        selectedColor: _kFormBlue,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        onSelected: (_) {
                          controller.signatureBorderWidth.value = w;
                          if (Get.isRegistered<TemplateController>()) {
                            Get.find<TemplateController>().refreshCardData();
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSignaturePreview() {
    final bytes = controller.signatureImageBytes.value;
    final path = controller.signaturePath.value;
    if (bytes != null && bytes.isNotEmpty) {
      return Image.memory(bytes, fit: BoxFit.fill);
    }
    if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.fill);
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.draw_rounded, size: 28, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          'No Signature',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

/// Join date row in a soft card (employee form reference).
class EmployeeJoinDateField extends StatelessWidget {
  const EmployeeJoinDateField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month_rounded, color: _kFormBlue, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JOIN DATE',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kFormBlue,
                      letterSpacing: 0.6,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [DdMmYyyyDashInputFormatter()],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: StudentUnderlineField._fieldDecoration.copyWith(
                      hintText: 'dd-mm-yyyy',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _kHint,
                      ),
                      contentPadding: const EdgeInsets.only(top: 2, bottom: 4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSubmitButton extends StatelessWidget {
  const StudentSubmitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kFormBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Text(
          'SUBMIT',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
