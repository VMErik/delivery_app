import 'dart:convert';
import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OrdersProvider{

  String _url =  Enviroment.API_DELIVERY;
  String _api  = 'api/orders';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser){
    this.context = context;
    this.sessionUser = sessionUser;
  }


  Future<List<Order>> getByStaus(String status) async{
    try{
      print(sessionUser.sessionToken);
      Uri uri = Uri.http(_url , '$_api/findByStatus/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }

  Future<List<Order>> getByDeliveryAndStatus(String idDelivery, String status) async{
    try{
      print(sessionUser.sessionToken);
      Uri uri = Uri.http(_url , '$_api/findByDeliveryAndStatus/$idDelivery/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }

  Future<List<Order>> getByClientAndStatus(String idClient, String status) async{
    try{
      print(sessionUser.sessionToken);
      Uri uri = Uri.http(_url , '$_api/findByClientAndStatus/$idClient/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }

  Future<ResponseApi> create(Order order) async{
    try{
      Uri uri = Uri.http(_url , '$_api/create');
      print(uri);
      String bodyParams = json.encode(order);
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


  Future<ResponseApi> updateToDispatched(Order order) async{
    try{
      Uri uri = Uri.http(_url , '$_api/updateToDispatched');
      print(uri);
      String bodyParams = json.encode(order);
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' :  sessionUser.sessionToken
      };

      final response = await http.put(uri,headers: headers, body: bodyParams);
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

  Future<ResponseApi> updateToOnTheWay(Order order) async{
    try{
      Uri uri = Uri.http(_url , '$_api/updateToOnTheWay');
      print(uri);

      String bodyParams = json.encode(order);
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' :  sessionUser.sessionToken
      };

      final response = await http.put(uri,headers: headers, body: bodyParams);
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


  Future<ResponseApi> updateToDelivered(Order order) async{
    try{
      Uri uri = Uri.http(_url , '$_api/updateToDelivered');
      print(uri);

      String bodyParams = json.encode(order);
      // Indicamos que lo que estamos viendo son json
      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Authorization' :  sessionUser.sessionToken
      };

      final response = await http.put(uri,headers: headers, body: bodyParams);
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