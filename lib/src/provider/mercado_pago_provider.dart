import 'dart:convert';

import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MercadoPagoProvider{

  String _urlMercadoPago  = 'api.mercadopago.com';
  final _mercadoPagoCredentials = Enviroment.mercadoPagoCredentials;

  BuildContext context;
  User user;

  Future init (BuildContext  context , User user){
    this.context = context;
    this.user  = user;
  }

  Future<Response> createCardToken({
    String cvv,
    String expirationYear,
    int expirationMonth,
    String cardNumber,
    String documentNumber,
    String identificationId,
    String cardHolderName
  }) async {
    try{
      final url = Uri.http(_urlMercadoPago, '/v1/card_tokens' , {
        'public_key' :  _mercadoPagoCredentials.publicKey
      });

      final body = {
        'security_code' : cvv ,
        'expiration_year' : expirationYear ,
        'expiration_month' : expirationMonth ,
        'card_number' : cardNumber ,
        'card_holder' : {
          'name' : cardHolderName
        },
      };
      final res = await http.post(url);
      return res;
      // Este es el original
      //final res = await http.post(url, body: json.encode(body));
      //return res;

    }catch(e){
      print('Error : $e');
      return null;
    }
  }

}
