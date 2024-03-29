import 'package:delivery_project/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class RestaurantCategoriesCreatePage extends StatefulWidget {
  const RestaurantCategoriesCreatePage({Key key}) : super(key: key);

  @override
  _RestaurantCategoriesCreatePageState createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {

  RestaurantCategoriesCreateController _con = new RestaurantCategoriesCreateController();

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
        title: Text('Nueva Categoria'),
      ),
      body: Column(
        children: [
          SizedBox(height: 14,),
          _textFieldName(),
          SizedBox(height: 14,),
          _textFieldDescription()
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
        onPressed: _con.CreateCategory,
        child: Text('Guardar Categorias'),
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



  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
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
            hintText: 'Descripcion de la categoria',
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
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre de la categoria',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.list_alt ,
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
