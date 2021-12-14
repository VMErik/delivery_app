import 'dart:convert';

import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/push_notifications_provider.dart';
import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class LoginController {

  // Null Safety con el signo de interrogacion
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();


  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  Future init(BuildContext context) async{
    this.context = context;
    await this.usersProvider.init(context);
    
    // Hacemos la validacion para ver si ya tenemos un login
    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    if (user.sessionToken != null){

      await pushNotificationsProvider.saveToken(user, context);


      if(user.roles.length > 1){
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false) ;
      }else{
        // Lo mandamos a otra pantalla, esto remueve el historico de pantallas,
        // lo que hace que esta nueva sea la principal y no el login
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false) ;
      }
    }
  }

  void goToRegisterPage(){
    Navigator.pushNamed(context, 'register');
  }

  void login() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ResponseApi responseApi = await usersProvider.login(email, password);
    if (responseApi.success){
      // Almacenamos informacion en un objeto
      _sharedPref.save('user', responseApi.data);

      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());

      await pushNotificationsProvider.saveToken(user , context);


      if(user.roles.length > 1){
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false) ;
      }else{
        // Lo mandamos a otra pantalla, esto remueve el historico de pantallas,
        // lo que hace que esta nueva sea la principal y no el login
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false) ;
      }
    }else{
      MySnackbar.show(context, responseApi.message);
    }
  }

}