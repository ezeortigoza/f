import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
    final movieRepository = ref.watch(movieRepositoryProvider); //llamo al movieRepository, es el corazon de todo lo que estamos haciendo
    return MovieMapNotifier(getMovie:  movieRepository.getMovieById);  //llamo a mi class moviemapnotifier, lo mando para que me busque por ID
});





typedef GetMovieCallback = Future<Movie>Function(String movieId);


class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {  //MANTENER en cache todas las peliculas que ya haya consultado

  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}): super({});

  Future<void> loadMovie(String movieId) async {
    if(state[movieId] != null) return;  //si tengo mi estado con ese ID con esa pelicula cargada no devuelvo nada
    print('Realizando peticion http');
    final movie = await getMovie(movieId); //mando a llamar mi funcion

    state = {...state, movieId: movie}; //clono todo el estado anterior con el operador SPREAD , luego va aapuntar al movieId (si la movie existe), sino va largar una excepcion
  }

}