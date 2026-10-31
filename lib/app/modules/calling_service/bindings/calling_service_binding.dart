import 'package:get/get.dart';

import '../controllers/calling_service_controller.dart';

class CallingServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallingServiceController>(
      () => CallingServiceController(messages: [], selectedVendors: {}),
    );
  }
}
