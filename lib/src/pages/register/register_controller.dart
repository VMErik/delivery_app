
import 'dart:io';
import 'dart:convert';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController{

  BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  // Es el que nos va a permitir hacer la llamada a NUestra API
  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  
  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    // Innicializamos nuestro usersprovider
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async{
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text;
    String pass = passwordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if ( email.isEmpty || name.isEmpty || lastName.isEmpty || phone.isEmpty
        || pass.isEmpty || confirmPass.isEmpty ){
      MySnackbar.show(context, 'Debes de ingresar todos los campos');
      return;
    }

    if(confirmPass !=  pass){
      MySnackbar.show(context, 'Las contraseñas no coinciden');
      return;
    }

    if(pass.length < 6){
      MySnackbar.show(context, 'Las contraseñas debe de tener al menos seis caracteres');
      return;
    }

    if (imageFile == null){
      MySnackbar.show(context, 'Seleccione una imagen');
      return ;
    }
    
    _progressDialog.show(max: 100, msg: 'Espere un momento....');
    isEnable = false;
    User user = new User(
      // Definimos como va a estar contituido nuestro user
      email: email,
      name: name,
      lastname: lastName,
      phone: phone,
      password: pass
    );

    Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) {
      _progressDialog.close();
      //ResponseApi responseApi  = await usersProvider.create(user);
      ResponseApi responseApi  = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA ${responseApi.toJson()}');
      // Mandamos nuestro mensaje
      MySnackbar.show(context, responseApi.message);
      if(responseApi.success){
        // Si es satisfactorai la respues, hacemos un delay de 3 segundos
        Future.delayed(Duration(seconds: 3) , (){
          Navigator.pushReplacementNamed(context, 'login');
        });
      }else{
        isEnable = true;
      }

    });
  }

  Future selectImage(ImageSource imageSource) async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null){
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('Galeria'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('Camara'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context,
        builder: (BuildContext context){
          return alertDialog;
        });
  }

  void goToLoginPage(){
    Navigator.pop(context);
  }

}