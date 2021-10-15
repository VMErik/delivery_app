import 'package:delivery_project/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:delivery_project/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key key}) : super(key: key);

  @override
  _ClientAddressCreatePageState createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {

  ClientAddressCreateController _con = new ClientAddressCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context, refresh);
    });

  }

  void refresh(){
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Direccion') ,
      ),
      body: Column(
        children: [
          _textCompleteData(),
          _textFieldAdress() ,
          _textFieldneighborhood(),
          _textFielRefPoint()
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }


  Widget _textFielRefPoint(){
    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.refPointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwayDisablesFocusNode(),
        decoration: InputDecoration(
            labelText: 'Punto de referencia' ,
            suffixIcon: Icon(
              Icons.map,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldAdress(){
    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.addressController,
        decoration: InputDecoration(
          labelText: 'Direccion' ,
          suffixIcon: Icon(
            Icons.location_on,
            color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }


  Widget _textFieldneighborhood(){
    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.neighborhoodController,
        decoration: InputDecoration(
            labelText: 'Colonia' ,
            suffixIcon: Icon(
              Icons.location_city,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }



  Widget _textCompleteData(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Completa estos datos',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19
        ),
      ),
    );
  }

  Widget  _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: Text('GUARDAR DIRECCION'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor
        ),
      ),
    );
  }



}


class AlwayDisablesFocusNode extends FocusNode{
  @override
  bool get hasFocus => false;
}