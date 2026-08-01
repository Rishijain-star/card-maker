import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoadingService extends GetxService {
  final RxBool isLoading = false.obs;
  final RxString loadingMessage = ''.obs;

  void show([String message = 'Loading...']) {
    loadingMessage.value = message;
    isLoading.value = true;
  }

  void hide() {
    isLoading.value = false;
    loadingMessage.value = '';
  }

  void forceHide() => hide();

  Future<T> run<T>(String message, Future<T> Function() action) async {
    show(message);
    try {
      return await action();
    } finally {
      hide();
    }
  }

  static AppLoadingService get to =>
      Get.isRegistered<AppLoadingService>()
          ? Get.find<AppLoadingService>()
          : Get.put(AppLoadingService());
}

class AppGlobalLoadingHost extends StatelessWidget {
  const AppGlobalLoadingHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          if (!Get.isRegistered<AppLoadingService>()) return const SizedBox.shrink();
          final service = Get.find<AppLoadingService>();
          if (!service.isLoading.value) return const SizedBox.shrink();
          return Container(
            color: Colors.black45,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  if (service.loadingMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      service.loadingMessage.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
