import 'package:get/get.dart';

class PromotionController extends GetxController{
  RxBool _promotion=true.obs;
  get promotion=>_promotion.value;

  set setPromotion(val)=>_promotion.value=val;
  @override
  void onInit() {
    _promotion=true.obs;
    super.onInit();
  }
}