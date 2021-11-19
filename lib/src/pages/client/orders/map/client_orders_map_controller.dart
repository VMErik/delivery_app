import 'dart:async';
import 'dart:ffi';

import 'package:delivery_project/src/api/enviroment.dart';
import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/response_api.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/orders_provider.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/utils/my_snackbar.dart';
import 'package:delivery_project/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:url_launcher/url_launcher.dart';

class ClientOrdersMapController{

  BuildContext context;
  Function refresh;

  //Almacenar la variables
  Position _position;
  StreamSubscription _positionStream;

  //
  String addressName;
  LatLng addressLatLng;

  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;

  Map<MarkerId, Marker> markers = <MarkerId ,Marker>{};

  Order order;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrdersProvider _ordersProvider = new OrdersProvider();

  // Esto es para los maps
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(19.9060594 , -99.337889),
      zoom: 14
  );

  Completer<GoogleMapController> _mapController = Completer();

  User user;
  SharedPref _sharedPref = new SharedPref();

  double _distanceBetween;

  Future init(BuildContext context, Function refresh)async{
    this.context = context;
    this.refresh = refresh;

    // Obtenemos la orden que enviamos desde donde se actualizo
    order = Order.fromJson(ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    deliveryMarker =  await createMarketFromAsset('assets/img/delivery2.png');
    homeMarker = await  createMarketFromAsset('assets/img/home.png');

    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user);
    checkGPS();
  }

  void isCloseToDeliveryPosition(){
    // Obtenemos la diistancia entre los dos puntos
    _distanceBetween = Geolocator.distanceBetween(
        _position.latitude, _position.longitude, order.address.lat, order.address.lng);
    print('****************Distancia entre los puntos ${_distanceBetween}');
  }


  void launchWaze() async {
    var url = 'waze://?ll=${order.address.lat},${order.address.lng}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${order.address.lat},${order.address.lng}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void launchGoogleMaps() async {
    var url = 'google.navigation:q=${order.address.lat},${order.address.lng}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${order.address.lat},${order.address.lng}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void updateToDelivered() async{
    print('Distancia final  ${ _distanceBetween }');
    // Si es menor a 200 metros , permite
    if (_distanceBetween <= 200){
      ResponseApi responseApi = await _ordersProvider.updateToDelivered(order);
      if(responseApi.success){
        Fluttertoast.showToast(msg: responseApi.message , toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(context, 'delivery/orders/list', (route) => false);
      }
    }else{
      //Manda mensaje que se acerque mas a la posciion de entrega
      MySnackbar.show(context, 'Debe estar mas cerca para poder marcar como entregada la orden');
    }
  }


  Future<void> setPolilines(LatLng from, LatLng to) async{
    PointLatLng pointFrom  = PointLatLng(from.latitude, from.longitude);
    PointLatLng pontTo  = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Enviroment.API_KEY, pointFrom, pontTo);
    for(PointLatLng point in result.points){
      points.add(LatLng(point.latitude, point.longitude));
    }
    
    Polyline polyLine = Polyline(
        polylineId: PolylineId('poly') ,
        color: Colors.redAccent ,
        points: points,
        width: 6
    );

    polylines.add(polyLine);
    refresh();

  }


  void addMarker(
      String markerId, double lat , double lng ,
      String title, String content, BitmapDescriptor iconMarker){

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(markerId: id , icon: iconMarker ,
        position: LatLng(lat, lng) , infoWindow: InfoWindow(title: title , snippet: content));
    markers[id] = marker;
    refresh();
  }

  void  selectRefPoint(){
    Map<String,dynamic> data = {
      'address' : addressName,
      'lat' : addressLatLng.latitude,
      'lng' : addressLatLng.longitude
    };
    Navigator.pop(context, data);
  }

  Future<BitmapDescriptor> createMarketFromAsset(String path) async{
    ImageConfiguration  configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  Future<Null> setLocationDraggableInfo() async{
    if(initialPosition != null){
      // Hay posicion
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng );
      if (address != null){
        if(address.length > 0){
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;
          addressName = '$direction #$street, $city, $department';
          addressLatLng = new LatLng(lat, lng);
          refresh();
        }
      }
    }
  }


  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]');
    _mapController.complete(controller);
  }

  Future animateCamaraToPosition(double lat, double lng) async{
    GoogleMapController controller = await _mapController.future;
    if(controller != null){
       controller.animateCamera(CameraUpdate.newCameraPosition(
         CameraPosition(
             target: LatLng(lat,lng),
             zoom: 13 ,
           bearing: 0
         )
       ));
    }
  }

  void checkGPS() async{
    // Validar si esta activado
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled){
      // Si esta habilitada, toma la posicion y actualiza el mapa
      updateLocation();
    }else{
      // El usuario no ha habilitado el gps
      bool locationGPS = await location.Location().requestService();
      if(locationGPS){
        updateLocation();
      }
    }
  }


  void dispose(){
    _positionStream?.cancel();
  }


  void updateLocation() async{
    try{
      // Obtiene ubicacion y genera los permisos
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); // Obtenemos latitdu y longitud de  posicion
      animateCamaraToPosition(_position.latitude, _position.longitude);
      addMarker('delivery', _position.latitude, _position.longitude, 'Tu posición', '', deliveryMarker);
      addMarker('home', order.address.lat, order.address.lng, 'Lugar de entrega', '', homeMarker);

      LatLng from  = LatLng(_position.latitude, _position.longitude);
      LatLng to  = LatLng(order.address.lat, order.address.lng);
      setPolilines( from , to);


      _positionStream = Geolocator.getPositionStream(
          desiredAccuracy : LocationAccuracy.best ,
         distanceFilter :  1
      ).listen((Position position){
        _position  = position;
        addMarker('delivery', _position.latitude, _position.longitude, 'Tu posición', '', deliveryMarker);
      });
      animateCamaraToPosition(_position.latitude, _position.longitude);
      isCloseToDeliveryPosition();

      refresh();
    }catch(e){
      print('Error: $e');
    }
  }

  void call(){
    launch('tel://${order?.client?.phone}');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // Determinamos si esta habilitada la ubicacion
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }


}