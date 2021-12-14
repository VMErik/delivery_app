// Definimos nuestra constante de la API
import 'package:delivery_project/src/models/mercado_pago_credentials.dart';

class Enviroment{
  static const String API_DELIVERY =  "192.168.100.11:3000";
  static const String API_KEY =  "AIzaSyBK8MVgGo7-pG84g3YJH_dk6QrHuOBxy_4";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-d108b98d-f1c1-465c-80a0-125aa5f8f96d',
      accessToken: 'TEST-4428765294320756-120120-f733f2452d8344f6495dcbfc8fcc84ae-269927470'
  );

}