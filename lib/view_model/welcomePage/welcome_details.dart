import 'package:get/get.dart';
import 'package:cityguide/view/homePage/homepage.dart';

class WelcomeController extends GetxController {
  void navigateToHomePage() {
    Get.offAll(() => const HomePage());
  }
}
