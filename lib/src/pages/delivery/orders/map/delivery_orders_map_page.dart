import 'package:delivery_project/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:delivery_project/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'delivery_orders_map_controller.dart';


class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({Key key}) : super(key: key);

  @override
  _DeliveryOrdersMapPageState createState() => _DeliveryOrdersMapPageState();
}

class _DeliveryOrdersMapPageState extends State<DeliveryOrdersMapPage> {

  DeliveryOrdersMapController _con = new DeliveryOrdersMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context, refresh);
    });

  }


  void refresh(){
    if(!mounted) return;
    setState(() {
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.60,
              child: _googleMap()
          ) ,
           SafeArea(
            child: Column(
              children: [
                _buttonCenterPosition() ,
                // Con este lo mandamos el card order en la parte de abajo
                Spacer(),
                _cardOrderInfo() ,
              ],
            ),
          ) ,
          Positioned(
            top: 40,
            left : 15,
            child: _iconGoogleMaps(),
          ),
          Positioned(
            top: 80,
            left : 15,
            child: _iconWaze(),
          )
        ],
      ),
    );
  }


  Widget  _buttonNext(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 2 , bottom: 5),
      child: ElevatedButton(
        onPressed: _con.updateToDelivered,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5) ,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  'ENTREGAR PRODUCTO',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ) ,
                ),
              ),
            ) ,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 45, top: 3),
                height: 30,
                child: Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _iconGoogleMaps(){
    return GestureDetector(
      onTap: _con.launchGoogleMaps,
      child: Image.asset('assets/img/google_maps.png',
      height: 35,
      width: 35,)
    );
  }


  Widget _iconWaze(){
    return GestureDetector(
        onTap: _con.launchWaze,
        child: Image.asset('assets/img/waze.png',
          height: 35,
          width: 35,)
    );
  }

  Widget _buttonCenterPosition(){
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
                Icons.location_searching ,
                color: Colors.grey[600],
                size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardOrderInfo(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30) ,
          topLeft: Radius.circular(30)
        ),
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5 ,
          blurRadius: 7,
          offset: Offset(0,3)
        )]
      ),
      child: Column(
        children: [
          _listTileAddress(_con.order?.address?.address , 'Direccion' , Icons.location_on  ) ,
          _listTileAddress(_con.order?.address?.neighborhood , 'Colonia' , Icons.my_location  ) ,
          //Linea divisora
          Divider(color: Colors.grey[400], endIndent: 30, indent: 30,) ,
          _clientInfo() ,
          _buttonNext()
        ],
      ),
    );
  }

  Widget _clientInfo(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35 , vertical:  20),
      child: Row(
        children: [
          // Imagen
          Container(
            height: 50 ,
            width: 50,
            child: FadeInImage(
              image: _con.order?.client?.image != null ? NetworkImage(_con.order?.client?.image) : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ) ,
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.client?.name} ${_con.order?.client?.lastname}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              maxLines: 1 ,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: IconButton(
              onPressed: _con.call,
              icon: Icon(Icons.phone , color:  Colors.black,),
            ),
          )
        ],
      ),
    );
  }

  Widget _listTileAddress(String title , String subtitle , IconData iconData ){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title ?? '', style: TextStyle(
          fontSize: 13
        ),
        ) ,
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
      ),
    );
  }


  Widget _googleMap(){
    return  GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }



}
