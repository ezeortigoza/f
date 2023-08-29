import 'package:cinemapedia/domain/entities/movie.dart';

//Los repositorios son los que van a llamar al DATASOURCE, me va a permitir cambiar el origen de dato, ya sea netflix API, themovieDB etc

abstract class RepositoryDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1}); //traeme todas las peliculas de ahora, y necesito que me especifique la pagina 
}