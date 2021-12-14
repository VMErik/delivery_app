
import 'dart:convert';

import 'package:delivery_project/src/models/mercado_pago_card_token.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/mercado_pago_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:http/http.dart';

class ClientPaymenstCreateController{
  BuildContext context;
  Function refresh;

  String cardNumber  = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  SharedPref _sharedPref = new SharedPref();

  User user;
  GlobalKey<FormState> keyForm = new GlobalKey();
  String expirationYear;
  int expirationMonth;

  MercadoPagoCardToken cardToken;

  Future init(BuildContext context , Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _mercadoPagoProvider.init(context, user);

  }


  void createCardToken() async{
    if (expireDate.isEmpty){
      MySnackbar.show(context, "Ingresa la fecha de expiración");
    }
    if (cvvCode.isEmpty){
      MySnackbar.show(context, "Ingresa el codigo de seguridad");
    }
    if (cardHolderName.isEmpty){
      MySnackbar.show(context, "Ingresa el titular de la tarjeta");
    }

    if(expireDate != null){
      List<String> list  = expireDate.split('/');
      if(list.length ==2){
        expirationMonth = int.parse(list[0]);
        expirationYear = '20${list[1]}';
      }else{
        MySnackbar.show(context, 'Inserte el mes y el año de expiración');
      }
    }

    print('CVV $cvvCode');
    print('CardNumber $cardNumber');
    print('Card Holder Name $cardHolderName');
    print('ExpirationYear $expirationYear');
    print('ExpirationMonth $expirationMonth');

    if (cardNumber != null){
      cardNumber = cardNumber.replaceAll(' ', '');
    }


    Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);


    //
    // Response response = await _mercadoPagoProvider.createCardToken(
    //     cvv: cvvCode ,
    //     cardNumber:  cardNumber ,
    //     cardHolderName: cardHolderName,
    //     identificationId: 'CC',
    //     documentNumber: '',
    //     expirationYear: expirationYear ,
    //     expirationMonth: expirationMonth
    // );

    // if(response != null){
    //   final data = json.decode(response.body);
    //   if (response.statusCode == 201){
    //     cardToken = new MercadoPagoCardToken.fromJsonMap(data);
    //     print('CARD TOKEN : ${cardToken.toJson()}');
    //
    //     Navigator.pushNamed(context, 'client/payments/installments');
    //
    //   }
    //   else{
    //     print('Ocurrio un error al generar el token de la tarjeta');
    //     int status = int.tryParse(data['cause'][0]['code'] ?? data['status']);
    //     String message = data['message'] ?? 'Error al registrar la tarjeta';
    //     MySnackbar.show(context, 'Status code $status  -  $message');
    //   }
    // }else{
    //   print('Ocurrio un error');
    // }


    //


  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel){
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;refresh();
  }

}