import 'package:cinemapedia/domain/entities/movie.dart';


abstract class LocalStorageDatasource {  //base de datos LOCAL
  Future<void> toggleFavorite(Movie movie);  //traigo todas las peliculas

  Future<bool> isMovieFavorite(int movieId); //voy fijandome mediante un booleano si esta en true o false, es decir si esta en fav o No

  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}); //quiero mostrarlos en 10 en 10
  
}