

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDataSource extends LocalStorageDatasource{
  
  late Future<Isar> db; //ponemos late porque la apertura a la db no es del todo sincrona, hay que esperar a que la db este lista para hacer conexiones
  IsarDataSource() {
    db = openDb();
  }

  Future<Isar> openDb() async {

    final dir = await getApplicationDocumentsDirectory(); //obtenemos la instancia del directorio

    if( Isar.instanceNames.isEmpty) { //si no tenemos ninguna instancia
      return await Isar.open( //estos esquemas los cree con el procedimiento de construccion, cuando se creo el movie.G. El inspector me deja ver como esta la base de dato local en el dispositivo
        [MovieSchema], 
        inspector: true,
        directory: dir.path //añadimos la propiedad del directorio
      );  
    }
    return Future.value(Isar.getInstance()); //regresamos la instancia
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
     final isar = await db; //mandamos a llamar mi DB, paa poder llamar todos los querys y la base de datos

     final Movie? isFavoriteMovie = await isar.movies  //el Movie es opcional porque puede que la encuentr como puede que no
     .filter()
     .idEqualTo(movieId)  //este ID es = a algo... 
     .findFirst();  //encuentro el primero

     return isFavoriteMovie != null;  //si es diferente de null regresa un valor booleano, si es nulo regresa FALSE o viceversa
  }


  @override
  Future<void> toggleFavorite(Movie movie) async {
    
    final isar = await db;

    final favoriteMovie = await isar.movies   //necesito saber si la pelicula esta en favorito o no..
    .filter()
    .idEqualTo(movie.id)
    .findFirst();  //tenemos la pelicula favorita

    if( favoriteMovie != null) {
      //borrar (no es nulo, borro)
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));   //se utiliza para eliminar, ponemos el isarId, porque esta indexado y ya sabe isar cual ID tenemos
      return;
    }
    //insertar (si es nulo inserto)
      isar.writeTxnSync(() => isar.movies.putSync(movie));  //lo inserto en el objeto de movies, y toodo de manera asincrona
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {

     final isar = await db;

    return isar.movies.where()
      .offset(offset)
      .limit(limit)
      .findAll();
  }
}