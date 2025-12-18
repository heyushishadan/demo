import 'package:get/get.dart';


class CounterController extends GetxController {
  final RxInt count = 0.obs;

  void increment() {
    count.value++;
  }

  void clear() {
    count.value = 0;
  }
}
