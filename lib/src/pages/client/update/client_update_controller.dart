
import 'dart:io';
import 'dart:convert';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController{

  BuildContext context;

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  // Es el que nos va a permitir hacer la llamada a NUestra API
  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;
  bool isEnable = true;

  User user;
  SharedPref _sharedPref  = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    // Innicializamos nuestro usersprovider
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    // Enviamos tambien nuestro token al provider
    usersProvider.init(context , sessionUser :  user );

    nameController.text = user.name;
    lastNameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update() async{
    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text;

    if (  name.isEmpty || lastName.isEmpty || phone.isEmpty){
      MySnackbar.show(context, 'Debes de ingresar todos los campos');
      return;
    }


    _progressDialog.show(max: 100, msg: 'Espere un momento....');
    isEnable = false;
    User myUser = new User(
      // Definimos como va a estar contituido nuestro user
        id :  user.id ,
        name: name,
        lastname: lastName,
        phone: phone,
        image : user.image
    );

    Stream stream = await usersProvider.update(myUser, imageFile);
    stream.listen((res) async {
      _progressDialog.close();
      //ResponseApi responseApi  = await usersProvider.create(user);
      ResponseApi responseApi  = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);

      if(responseApi.success){

        // Obtenemos nuevamente el usuario de base de datos
        user = await usersProvider.getById(myUser.id);
        print('usuario obtenido : ${user.toJson()}');
        // Guardamos el usuario en seison
        _sharedPref.save('user', user.toJson());
        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
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