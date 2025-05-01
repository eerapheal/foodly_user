import 'package:foodly_user/views/message/photoview/state.dart';
import 'package:get/get.dart';

class PhotoImageViewController extends GetxController {
  RxBool _loading = true.obs;
  RxString _url ="".obs;
  String get url => _url.value;


  bool get loading => _loading.value;

  set loading(bool val) => _loading.value=false;

  set url(String url) => _url.value=url;
}
