
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ClientProductsDetailController{

  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productoPrice;

  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProducts  = [];


  Future init(BuildContext context, Function refresh, Product product) async{
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productoPrice = product.price;

    //_sharedPref.remove('order');
    
    // Buscamos la lista de productos seleccionados
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    checkAdded();
    refresh();
  }

  void checkAdded(){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    if(index > -1){
      // Si hay
      counter = selectedProducts[index].quantity;
      productoPrice =  counter *  product.price;
      refresh();
    }
  }
  
  void addToBag(){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    if(index == -1){
      //No existe ese productos
      if (product.quantity == null){
          product.quantity = 1 ;
      }
      selectedProducts.add(product);
    }else{
      // Ya existe suma el counter
      selectedProducts[index].quantity = counter;
    }
    _sharedPref.save('order',selectedProducts);
    MySnackbar.show(context, 'Producto Agregado');
    close();
  }

  void addItem(){
    counter = counter +1 ;
    productoPrice = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem(){
    if (counter>1){
      counter = counter -1;
      productoPrice = product.price * counter;
      product.quantity = counter;
      refresh();
    }
  }



  void close(){
    Navigator.pop(context);
  }


}