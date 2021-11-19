import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:delivery_project/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:delivery_project/src/provider/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdersListController {
  BuildContext context;

  SharedPref _sharedPref = new SharedPref();
  // Para nuestro Menu
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user ;
  Function refresh;

  List<String> status = ['DESPACHADO'  , 'EN CAMINO' ,  'ENTREGADO'];
  OrdersProvider _ordersProvider = new OrdersProvider();
  bool isUpdated;


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') );
    _ordersProvider.init(context, user);

    refresh();
  }

  Future<List<Order>> getOrder(String status) async{
    return await _ordersProvider.getByDeliveryAndStatus( user.id ,status);
  }


  void openBottonSheet(Order order) async {
    isUpdated = await  showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdersDetailPage(order : order)
    );
    if (isUpdated){
      refresh();
    }
  }


  void logout(){
    _sharedPref.logout(context , user.id  );
  }

  // Metodo para abrir nuestro drawer
  void openDrawer(){
    key.currentState?.openDrawer();
  }


  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToCategoryCreate(){
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }


  void goToProductCreate(){
    Navigator.pushNamed(context, 'restaurant/products/create');
  }
}