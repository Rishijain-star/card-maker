import '../../modules/create_flow/controllers/create_flow_controller.dart';

/// Fields shown on lanyard strap preview.
class LanyardData {
  const LanyardData({
    this.organization = '',
    this.name = '',
    this.subtitle = '',
    this.logoPath = '',
    this.fontFamily = 'Inter',
    this.accentColorHex = 0xFF2563EB,
    this.repeatCount = 3,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  });

  final String organization;
  final String name;
  final String subtitle;
  final String logoPath;
  final String fontFamily;
  final int accentColorHex;
  final int repeatCount;
  final double offsetX;
  final double offsetY;

  factory LanyardData.fromCreateFlow(CreateFlowController flow) {
    final color = flow.palette[flow.selectedColor.value.clamp(0, flow.palette.length - 1)];
    return LanyardData(
      organization: flow.instituteCtrl.text.trim(),
      name: flow.fullNameCtrl.text.trim(),
      subtitle: flow.courseCtrl.text.trim(),
      logoPath: flow.photoPath.value,
      fontFamily: flow.selectedFontFamily,
      accentColorHex: color.toARGB32(),
      repeatCount: flow.lanyardRepeatCount.value,
      offsetX: flow.lanyardTextOffsetX.value,
      offsetY: flow.lanyardTextOffsetY.value,
    );
  }

  static const empty = LanyardData();
}
