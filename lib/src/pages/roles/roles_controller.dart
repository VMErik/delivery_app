

import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class RolesController{

  BuildContext context;
  User user;
  Function refresh;
  
  SharedPref sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    // Aqui obtenemos el usuario que se creo, y esta almacenado
    user = User.fromJson( await sharedPref.read('user') );
    refresh();
  }
  
  void goToPage(String route){
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

}