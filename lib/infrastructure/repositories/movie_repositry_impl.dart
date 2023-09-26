import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

class MovieRepositryImpl extends MovieRepository {   //esto se hace para que yo facilmente pueda cambiar los origenes de datos , pero cuando este con mis poviders de RIVERPOD simplemente llamo a la implementacion ya va a teener el DATASORUCE para llamar todo el mecanismo de funcionaldiad

  final MovieDataSource dataSource;
  MovieRepositryImpl(this.dataSource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
     return dataSource.getNowPlaying(page: page);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
     return dataSource.getPopular(page: page);  //mando a llamar del datasource mi getpopular
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return dataSource.getTopRated(page: page); //mando las paginas
  }
  
  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return dataSource.getUpComing(page: page);
  }
  
  @override
  Future<Movie> getMovieById(String id) {
    return dataSource.getMovieById(id);  //llamamos el datasource porque sabe que tiene ese metodo y podemos llamarlo.. 
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
     return dataSource.searchMovies(query);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) {

    return dataSource.getSimilarMovies(movieId);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) {

   return dataSource.getYoutubeVideosById(movieId);
  }

}