

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/config/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource{

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3' ,  //toda la base va a tener precargada o preconfigurada
    queryParameters: {
      'api_key' : Enviroment.movieDbKey,
      'language' : 'es-MX',
    }
  ));  //dio es un gestor de HTTP

  @override
  Future<List<Actors>> getActorByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits'); //traigo la data de mis actores
    final castResponse = CreditsResponse.fromJson(response.data); //lo paso a JSON
    final List<Actors> actors = castResponse.cast.map((cast) =>ActorMapper.casToEntity(cast)).toList(); //lo mapeo y lo convierto en una LISTA


     return actors;
  }

}