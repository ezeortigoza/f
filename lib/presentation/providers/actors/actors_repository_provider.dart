

import 'package:cinemapedia/config/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/config/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryPovider = Provider((ref) { //este provider es de solo lectura, es decir es inmutable, su objetivo es para que todos los providers puedan consultar todo desde aqui
  return ActorRepositoryImpl(ActorMovieDbDatasource()); //es el origen de datos para que funcione el movie repositry provider, es decir es el corazon de todo lo que estamos haciendo
}); 