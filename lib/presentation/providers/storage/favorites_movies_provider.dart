

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


 final favoritesMoviesProvider = StateNotifierProvider<StorageMoviesNotifier,Map<int,Movie>>((ref) {

  final LocalStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier( localStorageRepository: LocalStorageRepository);
} ); 



//la data va lucir asi , en este caso lo ahcemos con un mapa, pero se puede realizar con un LIST,SET etc
/* 
 {
    1237: Movie,
    1236: Movie,
    5647: Movie


 }
 */


class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>>{

  int page = 0; //necesito saber cuantas peliculas tengo actualmente

  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}):super({});

  Future<List<Movie>> loadNextPage() async {
     final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20); //muestra de 10 en 10 las peliculas, carga 20 peliculas ya de una
     page++; //incrementamos valor para que se se sigan sumando peliculas

     final tempMoviesMap = <int, Movie>{}; //me creo un map, key= INT y value= Movie
     for (final movie in movies) {
        tempMoviesMap[movie.id] = movie; //convierto mis movies en un MAP 
     }
     state = {...state, ...tempMoviesMap}; //traigo todas mis peliculas, y actualizo el estado

     return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {  //va a cumplir la misma funcion que el toggleFavorite, dar mg o quitar
    await localStorageRepository.toggleFavorite(movie);  //llamo a mi datasource
    final bool isMovieInFavorites = state[movie.id] != null;  //vamos a preguntar si la pelicula existe en el listado de favoritos

    if (isMovieInFavorites){
      state.remove(movie.id);  //si esta en el listado, lo puedo remover del estado
      state = {...state};  //actualizo el state
    }else {
      state = {...state, movie.id: movie};  //traigo la nueva pelicula
    }
  }





}