// lib/dependency_injection.dart

import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/counter_controller.dart';
import 'package:foodly_user/controllers/login_controller.dart';
import 'package:foodly_user/controllers/notifications_controller.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:foodly_user/controllers/cart_controller.dart';
import 'package:foodly_user/controllers/contact_controller.dart';
import 'package:foodly_user/controllers/catergory_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/controllers/promotion_controller.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/services/points_services.dart';

Future<void> initDependencies() async {
  await GetStorage.init();

  Get.put(CartController());
  Get.put(ContactController());
  Get.put(CounterController());
  Get.put(CategoryController());
  Get.put(UserLocationController());
  Get.put(PromotionController());
  Get.put(CategoryController());
  Get.put(LoginController());
  //Get.put(NotificationsController());
  // Lazy load services and controllers
  Get.lazyPut(()=> ReloadController(), fenix: true);
  Get.lazyPut(() => PointsServices(), fenix: true);
  Get.lazyPut<PointsController>(() => PointsController(), fenix: true);
  Get.lazyPut(() => CartCheckoutController(), fenix: true);
  Get.lazyPut(() => OrderController(), fenix: true);
  Get.lazyPut(() => AddressController(), fenix: true);
  Get.lazyPut(() => MainScreenController(), fenix: true);
  Get.lazyPut(() => AppSetupController(), fenix: true);

}
