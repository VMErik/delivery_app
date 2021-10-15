import 'dart:io';

import 'package:delivery_project/src/models/category.dart';
import 'package:delivery_project/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:delivery_project/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({Key key}) : super(key: key);

  @override
  _RestaurantProductsCreatePageState createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {

  RestaurantProductsCreateController _con = new RestaurantProductsCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Producto'),
        ),
        body: ListView(
          children: [
            SizedBox(height: 14,),
            _textFieldName(),
            SizedBox(height: 14,),
            _textFieldDescription(),
            SizedBox(height: 14,),
            _textFieldPrice() ,
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardImage(_con.imageFile1, 1),
                  _cardImage(_con.imageFile2, 2),
                  _cardImage(_con.imageFile3, 3),
                ],
              ),
            ), 
            _dropDownCategories(_con.categories)
          ],
        ),
        bottomNavigationBar : _buttonCreate()
    );
  }


  Widget _buttonCreate(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: Text('Guardar Producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }
  
  Widget _dropDownCategories(List<Category> categories){
    // Esta es la lista
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        // Establece sombra
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.primaryColor,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Categorias',
                    style: TextStyle(
                      color : Colors.grey,
                      fontSize: 16
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccionar categoria',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  items: _dropDownItem(categories),
                  value : _con.idCategory,
                  onChanged: (option){
                    setState(() {
                      _con.idCategory = option  ;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem(List<Category> categories){
    List<DropdownMenuItem<String>> list  = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name) ,
        value: category.id,
      ));
    });
    return list;
  }

  Widget _cardImage(File imageFile , int numberFile){
    return GestureDetector(
      onTap: (){
       _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image(
                  image : AssetImage('assets/img/product_image.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
    );
  }



  Widget _textFieldPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Precio',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.monetization_on ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLength: 255,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Descripcion del producto',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.description ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }


  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 ),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.nameController,
        maxLength: 150,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.local_pizza ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Function refresh(){
    setState(() {

    });
  }


}
