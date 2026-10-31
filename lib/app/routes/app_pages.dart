import 'package:get/get.dart';

import '../modules/calling_service/bindings/calling_service_binding.dart';
import '../modules/calling_service/views/calling_service_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/vendor/bindings/vendor_binding.dart';
import '../modules/vendor/views/vendor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VENDOR,
      page: () => const VendorView(),
      binding: VendorBinding(),
    ),
    GetPage(
      name: _Paths.CALLING_SERVICE,
      page: () => const CallingServiceView(),
      binding: CallingServiceBinding(),
    ),
  ];
}
