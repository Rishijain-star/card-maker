import 'package:get/get.dart';

import '../../../core/navigation/user_home_navigation.dart';
import '../../../services/local_storage_services/local_storage_services.dart';

class SplashController extends GetxController {
  void completeToStart() {
    final loggedIn = LocalStorageService().isLoggedIn();
    if (loggedIn) {
      UserHomeNavigation.offAllToUserHome();
    } else {
      Get.offAllNamed<void>('/welcome');
    }
  }
}
