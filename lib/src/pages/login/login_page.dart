import 'package:delivery_project/src/pages/login/login_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();

  // Esto es lo primero que se ejecuta, antes de la creacion de las vistas
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Inicializamos controladores
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }


  @override
  // Este corre el codigo de lo que se mostrara en la batalla
  Widget build(BuildContext context) {
    // El Scaffold es la estructura por default de toda nuestra pagina
    return Scaffold(
      body: Container(
        // Lo centramos en la pantalla
        width: double.infinity,
        child: Stack(
          children: [
            // Podemos definir donde queremos ubicar el elmento de la pantalla
            Positioned(
                top : -120,
                left: 75,
                child: _circleLogin()
            ),
            Positioned(
              child: _textoLogin(),
              left: 165,
              top : 80
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _lottieAnimation(),
                  _textFieldEmail(),
                  _textFieldPass(),
                  _buttonLogin(),
                  _textDontHaveAccount()
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿NO TIENES UNA CUENTA?',
          style: TextStyle(
              color: MyColors.primaryColor,
              fontStyle: FontStyle.normal
          ),
        ) ,
        SizedBox(width: 7),
        GestureDetector(
          // llamamos a nuestro controlador para que redirija
          onTap: _con.goToRegisterPage,
          child: Text(
            'REGISTRATE' ,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor
            ),
          ),
        ) ,
      ],
    );
  }

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
      child: ElevatedButton(
          onPressed: _con.login,
          child: Text('Ingresar'),
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

  Widget _textFieldPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)

      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
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

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)
            
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _con.emailController,
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

  Widget _imageBanner(){
    return Container(
      // POnemos separacion de arriba y de abajo
      margin: EdgeInsets.only(
          top :  100 ,
          bottom: MediaQuery.of(context).size.height * 0.15
      ),
      child: Image.asset(
        'assets/img/delivery.png',
        width: 200,
        height: 200,
      ),
    );
  }
  
  Widget _lottieAnimation(){
    return Container(
        // POnemos separacion de arriba y de abajo
        margin: EdgeInsets.only(
        top :  100 ,
        bottom: MediaQuery.of(context).size.height * 0.08
    ),
    child: Lottie.asset(
        'assets/json/delivery.json' ,
        width: 280,
        height: 300,
        fit: BoxFit.fill
    ) );
  }

  Widget _circleLogin(){
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColor
      ),
    );
  }

  Widget _textoLogin(){
    return Text(
      "LOGIN" ,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'NimbusSans'
      ),
    );
  }
}
