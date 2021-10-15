import 'package:delivery_project/src/models/address.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/pages/client/address/map/client_address_map_page.dart';
import 'package:delivery_project/src/provider/address_provider.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController{

  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();

  AddressProvider _addressProvider = new AddressProvider();
  Map<String, dynamic> refPoint;
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));

    _addressProvider.init(context, user);
  }

  void createAddress() async{
    String address = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = refPoint['lat'] ??  0;
    double lng = refPoint['lng'] ??  0;

    if(address.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0){
      MySnackbar.show(context, 'Completa todos los campos');
      return;
    }
    print('Entra');

    Address myAddress = new Address(
      idUser:  user.id ,
      address: address,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng
    );

    ResponseApi responseApi = await _addressProvider.create(myAddress);
    if(responseApi.success){

      myAddress.id = responseApi.data['id'];
      _sharedPref.save('address', myAddress);

      MySnackbar.show(context, responseApi.message);
      // Aqui enviamos el parametro que esta esperando
      Navigator.pop(context , true);
    }
  }

  void openMap() async{
    refPoint = await showMaterialModalBottomSheet(
        context: context,
        // Esto es para evitar que no se quite con el deslice
        isDismissible: false,
        enableDrag: false,
        builder: (context)=>ClientAddressMapPage());
    if(refPoint != null){
      // El usuario si nos envio la ubicacion
      refPointController.text =refPoint['address'];
      refresh();
    }
  }


}