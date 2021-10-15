import 'package:delivery_project/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:delivery_project/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key key}) : super(key: key);

  @override
  _ClientAddressMapPageState createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {

  ClientAddressMapController _con = new ClientAddressMapController();
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
        title : Text('Ubica tu direccion en el mapa'),
      ),
      body: Stack(
        children: [
          _googleMap() ,
          Container(
            child: _iconMyLocation(),
            alignment: Alignment.center,
          ),
          Container(
            child: _cardAddress(),
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
          ) ,
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonSelect(),
          )
        ],
      ),
    );
  }


  Widget  _buttonSelect(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 60),
      child: ElevatedButton(
        // Con este llamamos al metodo que guarda en data y lo manda al controller otro
        onPressed: _con.selectRefPoint,
        child: Text('SELECCIONAR ESTE PUNTO'),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor
        ),
      ),
    );
  }

  Widget _cardAddress(){
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              _con.addressName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white
                  ),
          ),
        ),
        color: Colors.blue,
      ),
    );
  }

  Widget _iconMyLocation(){
    return Image.asset(
        'assets/img/my_location.png' ,
      width: 65,
      height: 65,
    );
  }

  Widget _googleMap(){
    return  GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position){
        _con.initialPosition = position;
      },
      onCameraIdle: () async  {
        await _con.setLocationDraggableInfo();
      },
    );
  }



}
