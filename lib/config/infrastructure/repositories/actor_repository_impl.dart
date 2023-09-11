

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:cinemapedia/domain/repositories/actors_repositry.dart';

class ActorRepositoryImpl extends ActorsRepostory{ //sirve para poder cambiar el datasource facilmente, pero los metodos los toma desde ActorRepositoryImpl

  final ActorsDatasource datasource;

  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actors>> getActorByMovie(String movieId) {
    return datasource.getActorByMovie(movieId);  //el solo sirve de puente con la parte de gestor de estado, con el datasource
  }

}