import 'package:cinemapedia/domain/entities/movie.dart';

//creo una clase abstracta, porque no quiero crear instancias de ella..

abstract class MovieDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1}); //traeme todas las peliculas de ahora, y necesito que me especifique la pagina 
}