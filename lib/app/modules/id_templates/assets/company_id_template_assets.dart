/// Portrait company / employee ID — background PNGs and picker logos.
abstract final class CompanyIdTemplateAssets {
  static const String frontBackgroundV1 = 'assets/company 1st frnt.png';

  static const String backBackgroundV1 = 'assets/company 1st back.png';

  static const String frontBackgroundV2 = 'assets/company front 2.png';

  static const String backBackgroundV2 = 'assets/company front 2 back.png';

  static const String frontBackgroundV3 = 'assets/3rd company front.png';

  static const String backBackgroundV3 = 'assets/3rd company back.png';

  static const String frontBackgroundV4 = 'assets/4th company front.png';

  static const String backBackgroundV4 = 'assets/4th back comanpy.png';

  static const String frontBackgroundV5 = 'assets/front comapny 5.png';

  static const String backBackgroundV5 = 'assets/back company 5.png';

  static const String frontBackgroundV6 = 'assets/sisxth frotn comapny.png';

  static const String backBackgroundV6 = 'assets/sixsth back company.png';

  static const String frontBackgroundV7 = 'assets/7th frotn comapony.png';

  static const String backBackgroundV7 = 'assets/7th back company.png';

  static const String frontBackgroundV8 = 'assets/8th front company.png';

  static const String backBackgroundV8 = 'assets/8th backl company.png';

  static const String frontBackgroundV9 = 'assets/9th fronted company.png';

  static const String backBackgroundV9 = 'assets/9th backed company.png';

  static const String frontBackgroundV10 = 'assets/10th front company.png';

  static const String backBackgroundV10 = 'assets/10th back companyu.png';

  static const String frontBackgroundV11 = 'assets/11th company frotn.png';

  static const String backBackgroundV11 = 'assets/11th company bacl.png';

  /// Horizontal logo picker (index 1+); index 0 = no logo on card.
  static const List<String> logoPickerOptions = <String>[
    'assets/user.png',
    'assets/4276414.jpg',
    'assets/driver image.png',
  ];

  static String? logoAssetForPickerIndex(int pickerIndex) {
    if (pickerIndex <= 0) return null;
    final i = pickerIndex - 1;
    if (i < 0 || i >= logoPickerOptions.length) return null;
    return logoPickerOptions[i];
  }
}
