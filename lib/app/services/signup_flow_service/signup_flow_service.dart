import 'package:get/get.dart';

/// Holds signup wizard state across the 7-step verification flow.
class SignupFlowService extends GetxService {
  static void ensureRegistered() {
    if (!Get.isRegistered<SignupFlowService>()) {
      Get.put(SignupFlowService(), permanent: true);
    }
  }

  static SignupFlowService get I {
    ensureRegistered();
    return Get.find<SignupFlowService>();
  }

  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;

  /// Local file paths from image pickers (demo persistence).
  String? profilePhotoPath;
  String? selfiePath;

  /// `driver` | `passenger`
  final selectedRole = ''.obs;

  void clear() {
    fullName.value = '';
    email.value = '';
    phone.value = '';
    password.value = '';
    profilePhotoPath = null;
    selfiePath = null;
    selectedRole.value = '';
  }
}
