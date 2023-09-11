//quiero proveer mi repositorio
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/config/infrastructure/repositories/movie_repositry_impl.dart';



final movieRepositoryProvider = Provider((ref) { //este provider es de solo lectura, es decir es inmutable, su objetivo es para que todos los providers puedan consultar todo desde aqui
  return MovieRepositryImpl(MovieDbDatasource()); //es el origen de datos para que funcione el movie repositry provider, es decir es el corazon de todo lo que estamos haciendo
}); 