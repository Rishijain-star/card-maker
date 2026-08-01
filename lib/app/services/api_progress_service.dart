import 'package:get/get.dart';

/// Global top-of-screen progress (same visual language as onboarding).
/// Use for user-triggered API work; call [hide] in finally blocks.
class ApiProgressService extends GetxService {
  final visible = false.obs;
  final progress = 0.0.obs;
  final indeterminate = false.obs;
  final label = ''.obs;

  static ApiProgressService? tryGet() =>
      Get.isRegistered<ApiProgressService>() ? Get.find<ApiProgressService>() : null;

  void showIndeterminate(String text) {
    visible.value = true;
    indeterminate.value = true;
    label.value = text;
    progress.value = 0;
  }

  void showDeterminate(double value, String text) {
    visible.value = true;
    indeterminate.value = false;
    progress.value = value.clamp(0.0, 1.0);
    label.value = text;
  }

  void hide() {
    visible.value = false;
    indeterminate.value = false;
    progress.value = 0;
    label.value = '';
  }

  Future<T> run<T>(
    Future<T> Function() action, {
    String label = 'Loadingâ€¦',
  }) async {
    showIndeterminate(label);
    try {
      return await action();
    } finally {
      hide();
    }
  }
}

