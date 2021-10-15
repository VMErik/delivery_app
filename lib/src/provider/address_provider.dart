import 'dart:convert';
import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/address.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddressProvider{

  String _url =  Enviroment.API_DELIVERY;
  String _api  = 'api/address';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser){
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Address>> getByUser(String id) async{
    try{
      Uri uri = Uri.http(_url , '$_api/findByUser/$id');
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' :  sessionUser.sessionToken
      };
      final response = await http.get(uri,headers: headers);
      if (response.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesion Expirada');
        new SharedPref().logout(context , sessionUser.id);
      }
      // COnvertimos en el formato que lo necesitamos
      // Convertimos nuestro json a una lista de categorias
      final data = json.decode(response.body);
      Address address  = Address.fromJsonList(data);
      return address.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }


  Future<ResponseApi> create(Address category) async{
    try{
      Uri uri = Uri.http(_url , '$_api/create');
      String bodyParams = json.encode(category);
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' :  sessionUser.sessionToken
      };


      final response = await http.post(uri,headers: headers, body: bodyParams);
      if (response.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesion Expirada');
        SharedPref().logout(context, sessionUser.id);
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


}