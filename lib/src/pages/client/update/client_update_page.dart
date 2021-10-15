import 'package:delivery_project/src/pages/client/update/client_update_controller.dart';
import 'package:delivery_project/src/pages/register/register_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key key}) : super(key: key);

  @override
  _ClientUpdatePageState createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {

  ClientUpdateController _con = new ClientUpdateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30,),
                _imgUser(),
                SizedBox(height: 30,),
                _textFieldName(),
                _textFieldLastName() ,
                _textFieldPhone() ,
              ],
            ),
          ),
      ),
      // Pondra elementos en la parte inferior d ela pantalla
      bottomNavigationBar: _buttonRegister(),
    );
  }

  Widget _imgUser(){

    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage:  _con.imageFile != null
            ? FileImage(_con.imageFile)
            : _con.user?.image != null
              ? NetworkImage(_con.user?.image)
              : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.white,
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
            hintText: 'Nombre',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.person ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.lastNameController,
        decoration: InputDecoration(
            hintText: 'Apeliido',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.person_outline ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.phone ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }


  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.update : null ,
        child: Text('Actualizar Perfil'),
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

  void refresh(){
    setState(() {

    });
  }

}
