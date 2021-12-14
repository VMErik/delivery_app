
import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/orders_provider.dart';
import 'package:delivery_project/src/provider/push_notifications_provider.dart';
import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RestaurantOrdersDetailController{

  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productoPrice;

  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProducts  = [];
  double total = 0 ;
  Order order ;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  User user;
  String idDelivery;
  OrdersProvider _ordersProvider =new OrdersProvider();

  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  Future init(BuildContext context, Function refresh , Order order) async{
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context , sessionUser: user);
    _ordersProvider.init(context,user);
    // Obtenemos los productos seleccionados
    getTotal();
    getUsers();
    refresh();
  }

  void sendNotification(String tokenDelivery){
    Map<String, dynamic> data  =  {
      'click_action'  : 'FLUTTER_NOTIFICATION_CLICK'
    };
    print('Se envia la notificacion al usuario');
    pushNotificationsProvider.sendMessage(tokenDelivery, data, 'PEDIDO ASIGNADO', 'TE HAN ASIGNADO UN PEDIDO');
  }

  void getTotal(){
    total = 0;
    // Recorremos los productos que tiene la orden para poder moestrar el total
    order.products.forEach((product) {
      total = total + ( product.price  * product.quantity);
    });
    refresh();
  }


  void updateOrder() async{
    if(idDelivery != null){
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await  _ordersProvider.updateToDispatched(order);
      // Obtenemo la info del delivery
      User deliveryUser = await _usersProvider.getById(order.idDelivery);
      // La enviamos la notificacion
      sendNotification(deliveryUser.notificationToken);
      Fluttertoast.showToast(msg: responseApi.message ,toastLength: Toast.LENGTH_LONG );
      Navigator.pop(context , true);

    }else{
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
    }
  }

  void getUsers() async{
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }


}