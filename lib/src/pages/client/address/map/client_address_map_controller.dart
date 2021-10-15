import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClientAddressMapController{

  BuildContext context;
  Function refresh;

  //Almacenar la variables
  Position _position;

  //
  String addressName;
  LatLng addressLatLng;

  // Esto es para los maps
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(19.9060594 , -99.337889),
      zoom: 14
  );

  Completer<GoogleMapController> _mapController = Completer();

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;

    checkGPS();
  }


  void  selectRefPoint(){
    Map<String,dynamic> data = {
      'address' : addressName,
      'lat' : addressLatLng.latitude,
      'lng' : addressLatLng.longitude
    };
    Navigator.pop(context, data);
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


  void updateLocation() async{
    try{
      // Obtiene ubicacion y genera los permisos
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); // Obtenemos latitdu y longitud de  posicion
      animateCamaraToPosition(_position.latitude, _position.longitude);
    }catch(e){
      print('Error: $e');
    }
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