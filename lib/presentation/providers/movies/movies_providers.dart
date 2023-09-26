import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

  final nowPlayingMovieProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  //esto significa un proveedor de estado que notifica su cambio, especificamente ya voy a saber las peliculas 
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying; //el moviesNotifier es el controlador del estado
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});  

  final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  //esto significa un proveedor de estado que notifica su cambio, especificamente ya voy a saber las peliculas 
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular; //el moviesNotifier es el controlador del estado
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});  

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  //esto significa un proveedor de estado que notifica su cambio, especificamente ya voy a saber las peliculas 
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated; //el moviesNotifier es el controlador del estado
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});  

final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {  //esto significa un proveedor de estado que notifica su cambio, especificamente ya voy a saber las peliculas 
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpComing; //el moviesNotifier es el controlador del estado
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});  



typedef MovieCallBack = Future<List<Movie>> Function({int page}); //esto especifica el tipo de funcion que espero

class MoviesNotifier extends StateNotifier<List<Movie>>{ //que tipo de estado es el que voy a mantener dentro de el
  int currentPage = 0;
  bool isLoading = false; //Esto sirve para que el usuario cuando haga scroll no le carguen muchas peliculas, sino que se vayan cargando de a una
  MovieCallBack fetchMoreMovies;
  
  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);

  Future<void> loadNextPage() async{ //Carga las siguientes paginas de pelicula y mantenerlas en memoria
    if (isLoading) return;  //si esta en true que no haga nada mas, lo bloqueo para que no vuelva a hacer la peticion
  //si el loadin esta en false entra a este cuerpo
    isLoading = true;

    currentPage++; //le sumo uno mas cada vez que cambio de pagina
    final List<Movie> movies = await fetchMoreMovies(page: currentPage); //esta linea es para tener las movies
    state = [...state, ...movies]; //regresar un nuevo estado, cuando el estado cambia notifica al STATENOTIFIER
    //state modificacion del state, el state es un LISTADO DE MOVIE
    isLoading = false; //una vez que carga todo ya es false
  }
}