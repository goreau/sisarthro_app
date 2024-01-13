import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CapturaController>(() => CapturaController());
  }
}
