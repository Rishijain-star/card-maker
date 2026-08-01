import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../design_system/id_card_typography.dart';

/// Stylish font chips — [IdCardFontPickerLayout.grid] shows 3 per row;
/// [IdCardFontPickerLayout.strip] is a horizontal scroll (~3 visible on phone).
class IdCardFontPicker extends StatelessWidget {
  const IdCardFontPicker({
    super.key,
    required this.fonts,
    required this.selectedIndex,
    required this.onSelect,
    this.layout = IdCardFontPickerLayout.grid,
  });

  final List<String> fonts;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final IdCardFontPickerLayout layout;

  static const int gridColumns = 3;

  @override
  Widget build(BuildContext context) {
    if (layout == IdCardFontPickerLayout.strip) {
      return SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: fonts.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) => _FontChip(
            name: fonts[index],
            selected: selectedIndex == index,
            onTap: () => onSelect(index),
            compact: true,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final itemW =
            (constraints.maxWidth - gap * (gridColumns - 1)) / gridColumns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List<Widget>.generate(fonts.length, (index) {
            return SizedBox(
              width: itemW,
              child: _FontChip(
                name: fonts[index],
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
                compact: false,
              ),
            );
          }),
        );
      },
    );
  }
}

enum IdCardFontPickerLayout { grid, strip }

class _FontChip extends StatelessWidget {
  const _FontChip({
    required this.name,
    required this.selected,
    required this.onTap,
    required this.compact,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final previewStyle = IdCardTypography.apply(
      TextStyle(
        fontSize: compact ? 18 : 20,
        fontWeight: FontWeight.w700,
        color: selected ? Colors.white : const Color(0xFF0F172A),
      ),
      name,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 8,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  )
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(compact ? 12 : 14),
            border: Border.all(
              color: selected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
              width: selected ? 2 : 1.2,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: compact
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Aa', style: previewStyle),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Aa', style: previewStyle),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
