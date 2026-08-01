import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import '../../create_flow/controllers/products_controller.dart';
import '../../id_templates/controllers/template_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateFlowController>(() => CreateFlowController(), fenix: true);
    Get.lazyPut<TemplateController>(() => TemplateController(), fenix: true);
    Get.lazyPut<ProductsController>(() => ProductsController(), fenix: true);
  }
}
