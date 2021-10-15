import 'package:delivery_project/src/pages/register/register_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = new RegisterController();

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
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top : -120,
                left: 75,
                child: _circleRegister()
            ),
            Positioned(
                child: _textoRegister(),
                left: 148,
                top : 60
            ),
            Positioned(
                child: _iconBack(),
                left: 100,
                top : 45
            ),
            Container(
              margin: EdgeInsets.only(top: 150),
              width: double.infinity,
              // Esto lo metemos en un single Child Scroll View para poder hacer
              // el Scroll en la pantalla
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _imgUser(),
                    SizedBox(height: 30,),
                    _textFieldEmail() ,
                    _textFieldName(),
                    _textFieldLastName() ,
                    _textFieldPhone() ,
                    _textFieldPass() ,
                    _textFieldConfirmPassword() ,
                    _buttonRegister()
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _imgUser(){

    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage:  _con.imageFile != null
          ? FileImage(_con.imageFile)
          : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.white,
      ),
    );

  }

  Widget _circleRegister(){
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor
      ),
    );
  }

  Widget _textoRegister(){
    return
        Text(
          "REGISTRO" ,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'NimbusSans'
          ),
    );
  }

  Widget _iconBack(){
    return IconButton(
      onPressed: _con.goToLoginPage,
      icon: Icon(Icons.arrow_back_ios),
      color: Colors.white,
    );
  }

  Widget _textFieldEmail(){
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electronico',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.email ,
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

  Widget _textFieldPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.lock ,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }


  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        obscureText: true,
        controller: _con.confirmPasswordController,
        decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            // Para quitar el borde de nuestro textfield
            border: InputBorder.none ,
            // Para darle un padding al content
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.lock_outline ,
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
        onPressed: _con.isEnable ? _con.register : null ,
        child: Text('Registrar'),
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
