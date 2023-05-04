// Definimos nuestra constante de la API
import 'package:delivery_project/src/models/mercado_pago_credentials.dart';

class Enviroment{
  static const String API_DELIVERY =  "192.168.100.11:3000";
  static const String API_KEY =  "INTRODUCE AQUI TU API KEY";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'INTROUCE AQUI TU PUBLIC KEEY',
      accessToken: 'INTRODUCE AQUI EL ACCES TOKEN'
  );

}
