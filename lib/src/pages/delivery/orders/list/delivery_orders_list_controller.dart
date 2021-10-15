import 'package:delivery_project/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';

class DeliverOrdersListController {
  BuildContext context;

  SharedPref _sharedPref = new SharedPref();
  // Para nuestro Menu
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user ;
  Function refresh;
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') );
    refresh();
  }

  void logout(){
    _sharedPref.logout(context , user.id  );
  }

  // Metodo para abrir nuestro drawer
  void openDrawer(){
    key.currentState?.openDrawer();
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}