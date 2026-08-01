import 'package:get/get.dart';

import '../../routes/app_pages.dart';
abstract final class UserHomeNavigation {
  static void offAllToUserHome() {
    Get.offAllNamed<void>(Routes.WELCOME);
  }

  static void handleGlobalBottomTap(int index) {
    offAllToUserHome();
  }
}
