import 'package:delivery_project/src/pages/client/address/create/client_address_create_page.dart';
import 'package:delivery_project/src/pages/client/address/list/client_address_list_page.dart';
import 'package:delivery_project/src/pages/client/address/map/client_address_map_page.dart';
import 'package:delivery_project/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:delivery_project/src/pages/client/products/list/client_products_list_page.dart';
import 'package:delivery_project/src/pages/client/update/client_update_page.dart';
import 'package:delivery_project/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:delivery_project/src/pages/login/login_page.dart';
import 'package:delivery_project/src/pages/register/register_page.dart';
import 'package:delivery_project/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:delivery_project/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:delivery_project/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:delivery_project/src/pages/roles/roles_page.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App Flutter',
      initialRoute: 'login',
      routes: {
        // Ponemos todas las rutas, haciendo referencia a nuestras paginas
        'login' : (BuildContext contexto) => LoginPage(),
        'register' : (BuildContext contexto) => RegisterPage(),

        'client/products/list' : (BuildContext contexto) => ClientProductsListPage(),
        'client/update' :  (BuildContext contexto) => ClientUpdatePage() ,
        'client/orders/create' : (BuildContext contexto) => ClientOrdersCreatePage(),

        'client/address/list' : (BuildContext contexto) => ClientAddressListPage(),
        'client/address/create' : (BuildContext contexto) => ClientAddressCreatePage(),
        'client/address/map' : (BuildContext contexto) => ClientAddressMapPage(),

        'delivery/orders/list' : (BuildContext contexto) => DeliveryOrdersListPage(),

        'restaurant/orders/list' : (BuildContext contexto) => RestaurantOrdersListPage(),
        'restaurant/categories/create' : (BuildContext contexto) => RestaurantCategoriesCreatePage(),
        'restaurant/products/create' : (BuildContext contexto) => RestaurantProductsCreatePage(),

        'roles' : (BuildContext contexto) => RolesPage(),


      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(
          // Para quitar la sombre del AppBar
          elevation: 0
        )
      ),
    );
  }
}
