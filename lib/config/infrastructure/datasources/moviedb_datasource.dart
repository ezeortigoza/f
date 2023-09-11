//va a tener las interaciones con themovieDB
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/config/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/config/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:dio/dio.dart';
import '../../../domain/datasources/movies_datasource.dart';

class MovieDbDatasource extends MovieDataSource {  //el datasource es quien va a implementar todo esto, quien me va a traer la DATA especifica
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3' ,  //toda la base va a tener precargada o preconfigurada
    queryParameters: {
      'api_key' : Enviroment.movieDbKey,
      'language' : 'es-MX',
    }
  )); //dio es un gestor de HTTP

  List<Movie> _jsonToMovies(Map<String,dynamic> json){
     final movieDBResponse = MovieDbResponse.fromJson(json); //traigo la data 

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' )  //como es una lista puedo pasarlo por el metodo where, sino tiene "no-poster" no muestra nada, es decir no tiene su foto principal
    .map(
    (moviedb) => MovieMapper.movieDbToEntity(moviedb)
    ).toList(); //mapeo la data para luego mostrarla y regrresamos un listado de MOVIES
    return movies;
  }
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async{
    final response = await dio.get('/movie/now_playing', 
    queryParameters: {
      'page': page  //mando esto para que sigan apareciendo mas peliculas, sino siempre van aparecer las mismas
    }
    );

     return _jsonToMovies(response.data);
 }
 
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
      final response = await dio.get('/movie/popular',  //cambiamos el parametro por popular
    queryParameters: {
      'page': page  //mando esto para que sigan apareciendo mas peliculas, sino siempre van aparecer las mismas
    }
    );

    return _jsonToMovies(response.data);

   
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
      final response = await dio.get('/movie/top_rated',  //cambiamos el parametro por top_rated
    queryParameters: {
      'page': page  //mando esto para que sigan apareciendo mas peliculas, sino siempre van aparecer las mismas
    }
    );
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
     final response = await dio.get('/movie/upcoming',  //cambiamos el parametro por upcoming
    queryParameters: {
      'page': page  //mando esto para que sigan apareciendo mas peliculas, sino siempre van aparecer las mismas
    }
    );
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<Movie> getMovieById(String id) async {
     final response = await dio.get('/movie/$id');
     if(response.statusCode != 200) throw Exception('Movie with id: $id not found');

     final movieDetails = MovieDetails.fromJson(response.data);
     final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    
    return movie;  //implementamos el metodo de getMovieById, este seria la implementacion REAL
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {

    if(query.isEmpty) return [];
    
    final response = await dio.get('/search/movie',  //cambiamos el parametro por/search/movie
    queryParameters: {
      'query': query  //mando esto para que sigan apareciendo mas peliculas,en el query de busqueda
    }
    );
    return _jsonToMovies(response.data);
  }
  
}