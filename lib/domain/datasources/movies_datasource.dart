import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';

//creo una clase abstracta, porque no quiero crear instancias de ella..

abstract class MovieDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1}); //traeme todas las peliculas de ahora, y necesito que me especifique la pagina 
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<List<Movie>> getUpComing({int page = 1});
  Future<Movie> getMovieById(String id); //regresa una pelicula, es decir como va a lucir
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getSimilarMovies(int movieId);
  Future<List<Video>> getYoutubeVideosById(int movieId);



}