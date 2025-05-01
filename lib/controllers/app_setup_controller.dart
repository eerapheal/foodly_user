import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSetupController extends GetxController {
  final RxString _appVersion = "0.0".obs;
  final RxDouble _deliveryFee = 1.0.obs;


  String get appVersion => _appVersion.value;

  set appVersion(String val) => _appVersion.value = val;

  double get deliveryFee => _deliveryFee.value;
  //check whether to random shops or nearby shops
  final RxBool _isItemStatusShops = true.obs;

  bool get isItemStatusShops => _isItemStatusShops.value;

  set isItemStatusShops(bool val) => _isItemStatusShops.value=val;

  //check whether to random items or nearby items

  final RxBool _isItemStatusItems = true.obs;

  bool get isItemStatusItems => _isItemStatusItems.value;

  set isItemStatusItems(bool val) => _isItemStatusItems.value=val;

  @override
  void onReady() {
    super.onReady();
    _initializeAppVersion();
  }

  Future<void> _initializeAppVersion() async {
    final version = await readAppVersion();
    appVersion = version;
  }

  Future<String> readAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version; // Returns the app version
    } catch (e) {
      return "Unknown"; // Fallback in case of an error
    }
  }
}
