

import 'package:delivery_project/src/models/category.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/categories_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
class RestaurantCategoriesCreateController {

  BuildContext context;
  Function refresh;

  // Agregamos los controladores
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();


  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  User user;
  SharedPref sharedPref = new SharedPref();
  Future init(BuildContext context , Function refresh) async{
    this.context  = context;
    this.refresh = refresh;

    user  = User.fromJson( await  sharedPref.read('user') ) ;
    _categoriesProvider.init(context,user);
  }

  void CreateCategory() async{
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description .isEmpty){
      MySnackbar.show(context,'Debe de ingresar todos los campos');
      return;
    }
    print('Nombre $name ' );
    print('Description $description ' );

    Category category = new Category(
      name: name.toUpperCase() ,
      description: description.toUpperCase()
    );
    print('Llamamos al call');
    ResponseApi responseApi = await _categoriesProvider.create(category);

    MySnackbar.show(context, responseApi.message);

    if(responseApi.success){
      nameController.text = '';
      descriptionController.text = '';
    }

  }

}