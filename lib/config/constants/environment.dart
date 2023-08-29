import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String movieDbKey = dotenv.env['THE_MOVIE_KEY'] ?? 'No hay api key'; //voy a llamar las variables estaticas para que sean faciles de utilizar
}