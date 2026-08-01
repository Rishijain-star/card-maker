import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_shapes.dart';
import '../design_system/id_card_theme.dart';
import '../design_system/id_card_typography.dart';

enum StudentIdCardSide { front, back }

/// Production student ID card — Template 01 (widget-built, fully dynamic).
class StudentIdTemplate01 extends StatelessWidget {
  const StudentIdTemplate01({
    super.key,
    required this.data,
    required this.theme,
    this.side = StudentIdCardSide.front,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final IdCardTheme theme;
  final StudentIdCardSide side;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: IdCardDimensions.width,
      height: IdCardDimensions.height,
      child: side == StudentIdCardSide.front
          ? _Front(data: data, theme: theme, fontFamily: fontFamily)
          : _Back(data: data, theme: theme, fontFamily: fontFamily),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({
    required this.data,
    required this.theme,
    required this.fontFamily,
  });

  final StudentData data;
  final IdCardTheme theme;
  final String fontFamily;

  TextStyle _ts(TextStyle base) => IdCardTypography.apply(base, fontFamily);

  @override
  Widget build(BuildContext context) {
    final lines = data.frontBodyLines;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryDark.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            IdCardCircleLayer(theme: theme, topRight: true),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IdCardWaveHeader(
                  theme: theme,
                  height: 148,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 36),
                    child: Center(
                      child: AutoSizeText(
                        data.instituteName.trim(),
                        maxLines: 2,
                        minFontSize: 14,
                        textAlign: TextAlign.center,
                        style: _ts(
                          TextStyle(
                            color: theme.onPrimary,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      28,
                      8,
                      28,
                      data.hasSignature ? 96 : 48,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IdCardPhotoFrame(
                          theme: theme,
                          photoPath: data.photoPath,
                          diameter: 188,
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (lines.isNotEmpty)
                                _ValueLine(
                                  value: lines.first,
                                  theme: theme,
                                  fontFamily: fontFamily,
                                  emphasize: true,
                                ),
                              ...lines.skip(lines.isEmpty ? 0 : 1).map(
                                    (v) => Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: _ValueLine(
                                        value: v,
                                        theme: theme,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 24,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'STUDENT ID',
                  style: _ts(
                    TextStyle(
                      color: theme.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            if (data.hasSignature)
              Positioned(
                right: 20,
                bottom: 12,
                child: IdCardSignatureImage(
                  signaturePath: data.signaturePath,
                  signatureBytes: data.signatureBytes,
                  width: 210,
                  height: 92,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({
    required this.data,
    required this.theme,
    required this.fontFamily,
  });

  final StudentData data;
  final IdCardTheme theme;
  final String fontFamily;

  TextStyle _ts(TextStyle base) => IdCardTypography.apply(base, fontFamily);

  @override
  Widget build(BuildContext context) {
    final lines = data.backDetailLines;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryDark.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            IdCardCircleLayer(theme: theme, topRight: false),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IdCardWaveHeader(
                  theme: theme,
                  height: 96,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        data.instituteName.trim(),
                        maxLines: 1,
                        minFontSize: 12,
                        style: _ts(
                          TextStyle(
                            color: theme.onPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: lines.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return _ValueLine(
                          value: lines[index],
                          theme: theme,
                          fontFamily: fontFamily,
                          multiline: lines[index].length > 42,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Card text line — value only, no field label.
class _ValueLine extends StatelessWidget {
  const _ValueLine({
    required this.value,
    required this.theme,
    required this.fontFamily,
    this.emphasize = false,
    this.multiline = false,
  });

  final String value;
  final IdCardTheme theme;
  final String fontFamily;
  final bool emphasize;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final style = IdCardTypography.apply(
      TextStyle(
        fontSize: emphasize ? 20 : 15,
        fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
        color: theme.textPrimary,
        height: multiline ? 1.35 : 1.2,
      ),
      fontFamily,
    );

    if (multiline) {
      return Text(
        value,
        style: style,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );
    }

    return AutoSizeText(
      value,
      maxLines: emphasize ? 2 : 1,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
