

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository{

  final LocalStorageDatasource dataSource; //traigo mi data source, aca puedo traer cualquier base da datos, ya sea isar, sqlite, firebase ETC

  LocalStorageRepositoryImpl(this.dataSource);

  @override
  Future<bool> isMovieFavorite(int movieId) {
     return dataSource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return dataSource.loadMovies(limit: limit,offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return dataSource.toggleFavorite(movie);
  }

}