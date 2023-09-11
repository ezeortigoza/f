import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref)  {
  final nowPlayingMovies = ref.watch(nowPlayingMovieProvider); //traemos las peliculas de nowPlayingProvider

  if(nowPlayingMovies.isEmpty)return []; //es decir si esta vacio, y si esta vacio retornamos arreglo vacio

  return nowPlayingMovies.sublist(0,8); //caso contrario quiero mi sublista de 0 a 6
});