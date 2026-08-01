import 'package:get/get.dart';

import '../../../data/models/app_product.dart';
import '../../../services/product_api_service.dart';

class ProductsController extends GetxController {
  ProductsController({ProductApiService? api})
      : _api = api ?? ProductApiService();

  final ProductApiService _api;

  final RxList<AppProduct> products = <AppProduct>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DateTime?> lastFetchedAt = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool force = false}) async {
    if (isLoading.value) return;
    if (!force && products.isNotEmpty && lastFetchedAt.value != null) {
      final age = DateTime.now().difference(lastFetchedAt.value!);
      if (age.inSeconds < 30) return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _api.fetchActiveProducts();
      products.assignAll(list);
      lastFetchedAt.value = DateTime.now();
    } catch (e) {
      errorMessage.value = 'Could not load products. Check admin server & Wi‑Fi.';
    } finally {
      isLoading.value = false;
    }
  }

  AppProduct? findById(int id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
