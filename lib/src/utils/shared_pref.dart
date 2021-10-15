import 'dart:convert';

import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  // Este metodo lo utilizaremos  para guardar valres
  void save(String key, value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString( key , json.encode(value));
  }
  // Este metodo se utililza para leer
  Future<dynamic> read(String key) async{
    final pref = await SharedPreferences.getInstance();
    if(pref.getString(key)  == null){
      return null;
    }
    return json.decode( pref.getString(key) );
  }

  // Este es para saber si existe algun dato
  Future<bool> contains(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }

  // Este es para remover alguna Key
  Future<bool> remove(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  void logout(BuildContext context ,String idUser) async{
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);

    await usersProvider.logout(idUser);
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

}