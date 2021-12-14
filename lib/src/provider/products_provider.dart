import 'dart:convert';
import 'dart:io';
import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class ProductsProvider{

  String _url =  Enviroment.API_DELIVERY;
  String _api  = 'api/products';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser){
    print('Entro');
    this.context = context;
    this.sessionUser = sessionUser;
  }


  Future<List<Product>> getByCategory(String idCategory) async{
    try{
      Uri uri = Uri.http(_url , '$_api/findByCategory/$idCategory');
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
      Product product = Product.fromJsonList(data);
      return product.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }

  Future<List<Product>> getByCategoryAndProducName(String idCategory, String productName) async{
    try{
      Uri uri = Uri.http(_url , '$_api/findByCategoryAndProductName/$idCategory/$productName');
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
      Product product = Product.fromJsonList(data);
      return product.toList;
    }catch(e){
      print('Error $e');
      return [];
    }
  }


  Future<Stream> create(Product product , List<File> image) async{
    try{
      Uri url = Uri.http(_url , '$_api/create');
      final request = http.MultipartRequest( 'POST' , url);
      request.headers['Authorization'] = sessionUser.sessionToken;
      for(int  i  = 0 ; i < image.length; i++){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image[i].openRead().cast()),
            await image[i].length(),
            filename: basename(image[i].path)
        ));
      }

      request.fields['product'] = json.encode(product);

      final response = await request.send(); // Aqui se envia la peticion
      return response.stream.transform(utf8.decoder);

    }catch(e){
      print('Error $e');
      return null;
    }
  }


}