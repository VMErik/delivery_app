import 'dart:convert';
import 'dart:io';
import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider{
  // Aqui vamos a llamar a nuestra API
  String _url = Enviroment.API_DELIVERY;
  // POnemos la ruta que atiende nuestro server
  String _api = "/api/users";

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, {User sessionUser} ){
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<Stream> createWithImage(User user , File image) async{
    try{
      Uri url = Uri.http(_url , '$_api/create');
      final request = http.MultipartRequest( 'POST' , url);
      if(image != null){
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Aqui se envia la peticion
      return response.stream.transform(utf8.decoder);

    }catch(e){
      print('Error $e');
      return null;
    }
  }


  Future<Stream> update(User user , File image) async{
    try{
      Uri url = Uri.http(_url , '$_api/update');
      final request = http.MultipartRequest( 'PUT' , url);
      request.headers['Authorization'] =  sessionUser.sessionToken;
      if(image != null){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Aqui se envia la peticion
      
      if (response.statusCode == 401){ // Unahtuorized
        Fluttertoast.showToast(msg: 'Tu sesion ha expirado');
        new SharedPref().logout(context , sessionUser.id);
      }
      
      return response.stream.transform(utf8.decoder);

    }catch(e){
      print('Error $e');
      return null;
    }
  }


  Future<ResponseApi> create(User user) async{
    try{
      Uri uri = Uri.http(_url , '$_api/create');
      String bodyParams = json.encode(user);
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
      };

      final response = await http.post(uri,headers: headers, body: bodyParams);
      // Almacenamos la respuesta de nuestra API
      final data = json.decode(response.body);
      // Lo convertimos a nuestro response Api
      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    }catch(e){
      print('Error $e');
      ResponseApi responseApi =  new ResponseApi
        (message: 'Error en el front', error: e.toString(), success: false);
      return responseApi;
    }
  }

  Future<ResponseApi> updateNotificationToken(String idUser , String token) async{
    try{
      Uri uri = Uri.http(_url , '$_api/updateNotificationToken');
      String bodyParams = json.encode({
        'id' :  idUser ,
        'notification_token' :  token
      });

      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' : sessionUser.sessionToken
      };

      final response = await http.put(uri,headers: headers, body: bodyParams);

      // Validamos si esta autorizado
      if (response.statusCode == 401){ // Unahtuorized
        Fluttertoast.showToast(msg: 'Tu sesion ha expirado');
        new SharedPref().logout(context , sessionUser.id);
      }

      // Almacenamos la respuesta de nuestra API
      final data = json.decode(response.body);
      // Lo convertimos a nuestro response Api
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }catch(e){
      print('Error $e');
      ResponseApi responseApi =  new ResponseApi
        (message: 'Error en el front', error: e.toString(), success: false);
      return responseApi;
    }
  }




  Future<ResponseApi> logout(String idUser) async{
    try{
      Uri uri = Uri.http(_url , '$_api/logout');
      String bodyParams = json.encode({
        'id' :  idUser
      });

      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
      };

      final response = await http.post(uri,headers: headers, body: bodyParams);
      // Almacenamos la respuesta de nuestra API
      final data = json.decode(response.body);
      // Lo convertimos a nuestro response Api
      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    }catch(e){
      print('Error $e');
      ResponseApi responseApi =  new ResponseApi
        (message: 'Error en el front', error: e.toString(), success: false);
      return responseApi;
    }
  }



  Future<ResponseApi> login(String email, String password) async{
    try{
      Uri uri = Uri.http(_url , '$_api/login');
      String bodyParams = json.encode({
        'email' : email,
        'password' : password
      });
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
      };
      final response = await http.post(uri,headers: headers, body: bodyParams);
      // Almacenamos la respuesta de nuestra API
      final data = json.decode(response.body);
      // Lo convertimos a nuestro response Api
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }catch(e){
      print('Error $e');
      ResponseApi responseApi =  new ResponseApi
        (message: 'Error en el front ', error: e.toString(), success: false);
      return responseApi;
    }
  }

  Future<User> getById(String id) async{
    try{
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String,String> headers = {

        'Content-type' : 'application/json',
        'Authorization' : sessionUser.sessionToken
      };
      
      final resp = await http.get(url,headers: headers);
      
      if (resp.statusCode == 401){//Unauthorzed
        Fluttertoast.showToast(msg: 'Tu sesión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      
      final data = json.decode(resp.body);

      User user = User.fromJson(data);
      return user;
    }catch(e){
      print('Error $e');
      return null;
    }

  }


  Future<List<User>> getDeliveryMen() async{
    try{
      Uri url = Uri.http(_url, '$_api/findDeliveryMen');
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' : sessionUser.sessionToken
      };

      final resp = await http.get(url,headers: headers);
      if (resp.statusCode == 401){//Unauthorzed
        Fluttertoast.showToast(msg: 'Tu sesión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(resp.body);
      User user = User.fromJsonList(data);
      return user.toList;
    }catch(e){
      print('Error $e');
      return null;
    }

  }



}