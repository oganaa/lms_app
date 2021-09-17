import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms_app/constants/route_names.dart';
import 'package:lms_app/services/navigation_service.dart';
import '../locator.dart';
import 'base_ctrl.dart';

class LoginController extends BaseController {
  final NavigationService _navigationService = locator<NavigationService>();

  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;
  bool isLoginCheck = false;
  Color left = Colors.black87;
  Color right = Colors.white;
  String dropdownValue = 'Сонгоно уу..';
  List<Org> orgs = <Org>[ Org(id:'zg',name:'ЗГХЭГ'),Org(id:'uix',name:'УИХ-ын ТГ'),];
  Org selectedOrg;

  void initialise(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    notifyListeners();
  }

  void onChangePage(int i){
    if (i == 0) {
      right = Colors.white;
      left = Colors.black;
    } else if (i == 1) {
      right = Colors.black;
      left = Colors.white;
    }
    notifyListeners();
  }
  void selectOrg(Org newValue){
    selectedOrg = newValue;
    notifyListeners();
  }
  void jumpToHome(){
    _navigationService.navigateTo(HomeViewRoute);
  }
  void onSignInButtonPress( PageController pageController ){
    print('onSign');
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
  void onSignUpButtonPress( PageController pageController ){
    print('onSign');
    pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
  void toggleLogin(){
    obscureTextLogin = !obscureTextLogin;
    notifyListeners();
  }
  void checkBox(value){
    isLoginCheck = value;
    notifyListeners();
  }

}
class Org {
  String id;
  String name;
  Org({this.id, this.name});
}