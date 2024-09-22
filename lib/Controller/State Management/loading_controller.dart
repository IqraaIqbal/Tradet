import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Loading extends GetxController{
  bool loading=false;

  isClickedTrue(){
    loading=true;
    update();
  }
  isClickedFalse(){
    loading=false;
    update();
  }
}