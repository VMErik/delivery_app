import 'package:delivery_project/src/models/address.dart';
import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/address_provider.dart';
import 'package:delivery_project/src/provider/orders_provider.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';

class ClientAddressListController{

  BuildContext context;
  Function refresh;
  List<Address> address = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;
  bool isCreated = false;
  Map<String, dynamic> dataIsCreated;

  OrdersProvider _ordersProvider = new OrdersProvider();


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    
    user = User.fromJson(await _sharedPref.read('user'));
    // Obtenemos la lista de productos seleccionados en la orden

    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    refresh();
  }


  void createOrder() async {
    // Obtenemos direccion seleccionada y lista de productos
    Address a  = Address.fromJson(await _sharedPref.read('address') ?? {});
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    // Creamos nuestro modelo
    Order order = new Order(
      idClient: user.id ,
      idAddress: a.id,
      products: selectedProducts
    );
    ResponseApi responseApi = await _ordersProvider.create(order);

    Navigator.pushNamed(context, 'client/payments/create');

    print('Respuesta Orden : ${responseApi.message} ' );

  }


  void handleRadioValueChange(int value) async{
    radioValue = value;
    // Almacenamos lo seleccionado de la direccion
    _sharedPref.save('address', address[value]);
    refresh();
  }

  Future<List<Address>> getAddress() async{
    address = await _addressProvider.getByUser(user.id);
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});

    int index = address.indexWhere((ad) => ad.id == a.id);
    if (index != -1){
      // La direccion que traemos guardada esta dentro de la lista de todas las direccion
      radioValue = index;
    }

    return address;
  }


  void goToNewAddress() async{
    var result = await Navigator.pushNamed(context, 'client/address/create');
    if (result != null){
      if(result){
        refresh();
      }
    }
  }


}