import 'package:delivery_project/src/models/category.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:delivery_project/src/provider/categories_provider.dart';
import 'package:delivery_project/src/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController {
  BuildContext context;

  SharedPref _sharedPref = new SharedPref();
  // Para nuestro Menu
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Function refresh;
  User user ;
  List<Category> categories  = [];
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh =  refresh;
    user = User.fromJson(await _sharedPref.read('user') );
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }


  void goToOrdersList(){
    Navigator.pushNamed(context, 'client/orders/list');
  }

  Future<List<Product>> getProducts(String idCategory) async{
    return await _productsProvider.getByCategory(idCategory);
  }


  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void openBottomSheet(Product productoSelec){
    showMaterialModalBottomSheet(
      context: context,
      // Mandamos nuestra pagina que queremos que se muestre
      builder: (context) => ClientProductsDetailPage(product:productoSelec ,)
    );
  }

  void goToOrderCreatePage(){
    Navigator.pushNamed(context, 'client/orders/create');
  }


  void logout(){
    _sharedPref.logout(context, user.id);
  }

  // Metodo para abrir nuestro drawer
  void openDrawer(){
    key.currentState?.openDrawer();
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context, 'client/update');
  }

}