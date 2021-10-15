
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ClientOrdersCreateController{

  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productoPrice;

  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProducts  = [];

  double total = 0 ;


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    // Obtenemos los productos seleccionados
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    getTotal();
    refresh();
  }

  void getTotal(){
    total = 0;

    selectedProducts.forEach((product) {
      total = total + (product.quantity * product.price);
    });
    refresh();
  }

  void addItem(Product product){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity + 1;
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void removeItem(Product product){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    if(selectedProducts[index].quantity > 1){
      selectedProducts[index].quantity = selectedProducts[index].quantity - 1;
      _sharedPref.save('order', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.removeAt(index);
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void  goToAddress(){
    Navigator.pushNamed(context, 'client/address/list');
  }

}