import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';




typedef SearchMoviesCallback = Future <List<Movie>>Function(String query); //esta es la funciopn que voy a llamar para traer mis peliculas

class SearchMovieDelegate extends SearchDelegate<Movie?>{ //quiero devolver movie opcional

  final SearchMoviesCallback searchMovies;//llamo la funcion
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast(); //el broadcast puede escuchar en varios lugares el listener , el debounce nos sirve para que no se dispare todo el tiempo la busqueda de peliculas, recien termina de dispararse cuando el usuario termino de escribir
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer; //es como el setTimeOut de javascript


  SearchMovieDelegate({ //creo su constructor
    required this.searchMovies, 
    required this.initialMovies
    }):super(
      textInputAction: TextInputAction.go
    );

  void clearStreams() {
    debouncedMovies.close();  //esto es para cerrar el debouncedmovies definitivamente y que no viva en memoria cuando busco las peliculas
  }


  void _onQueryChanged(String query)  {  //Esto es para saber cuando escribe o deja de escribir el usuario

      isLoadingStream.add(true); //cuando escribo lo giro
      print('query cambio');
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel(); //si esto tiene un valor puede ser nulo sino false, pero sie sta activo voy a limpiarlo
    _debounceTimer = Timer(const Duration(microseconds: 500), () async {  //Espermaos 500 miliseconds cuando deja de escribir el usuario
       /*  if (query.isEmpty){   //aqui es donde vamos a realizar la peticion HTTP
            debouncedMovies.add([]); //agrego vacio porque no se pidio ninguna pelicula
            return;
        }  */

        final movies = await searchMovies(query); //me traigo las peliculas
        initialMovies = movies; //cuando tengo el valor va a ser lo mismo que las peliculas
        debouncedMovies.add(movies); // y añado las peliculas 
        isLoadingStream.add(false); //cuando dejo de escribir no gira mas 
    });
  }


  Widget buildResultsAndSuggestions () {
      return StreamBuilder(
        initialData: initialMovies, //esto sirve para que no vuelva a pedir otra peticion HTTP una vez cargadas todas las peliculas
        stream: debouncedMovies.stream, //esto seria lo que escriba el usuario
        //initialData: const [], //arranca con un arreglo vacio ese value o mejor dicho query
        builder: (context, snapshot) {
          final movies = snapshot.data ?? []; //el snapshot me trae toda la data, y arranca con un arreglo vacio
          return ListView.builder(
            itemCount: movies.length,  //traigo todo el length de mi query
            itemBuilder: (context, index) {
              //final movie = movies[index];
              return _MovieItem(
                movie: movies[index], 
                onMovieSelected: (context,movie){
                  clearStreams();
                  close(context,movie);
                }
              );
            },
          );
        },
    );
  }



  @override
  String get searchFieldLabel => 'Buscar pelicula'; //cambio el label de la caja de busqueda

  @override
  List<Widget>? buildActions(BuildContext context) { //esto sirve para construir las acciones
      return [
            StreamBuilder(
              initialData: false, //inicia en falso
              stream: isLoadingStream.stream,
              builder: (context, snapshot) {
                  if(snapshot.data ?? false){  //si es verdad que esta cargando regresamos el spin, y sino falso
                    return SpinPerfect(
                    duration: const Duration(seconds: 20),
                    spins: 10,
                    infinite: true,
                  child: IconButton(
                    onPressed: () => query = '',  //pongo query que seria en este caso el "value" ya viene por defecto con searchdelegate y quiero que sea vacio, es decir cuando toco la X borro todo
                    icon: const Icon(Icons.refresh_rounded, color: Colors.blue,),
                  ),
                );
                  }
                  return FadeInRight(
                   animate: query.isNotEmpty, //en vez de hacer la condicion IF en el paquete animate_do tengo la opcion para que aparezca o no
             //    duration: const Duration(milliseconds: 10),
                   child: IconButton(
                  onPressed: () => query = '',  //pongo query que seria en este caso el "value" ya viene por defecto con searchdelegate y quiero que sea vacio, es decir cuando toco la X borro todo
                     icon: const Icon(Icons.clear, color: Colors.blue,),
             ),
           ); 
         },
       ),

           // if(query.isNotEmpty) //siempre se utiliza isEmpty o isNotEmpty pero el NULL nunca
           
             // if(query.isNotEmpty) //siempre se utiliza isEmpty o isNotEmpty pero el NULL nunca
            
      ];
    
  }

  @override
  Widget? buildLeading(BuildContext context) {   //para construir un icono en la parte del inicio del appbar

      return IconButton(
        onPressed: () => {
          clearStreams(), //para limpiar todo lo que teniamos en memoria
          close(context, null) //el close es propio de searchdelegate, el result es lo que yo quiero regresar cuando cierrre en este caso NULL porque no selecciono ninguna pelicula
          } ,  
        icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.blue,),
     );
    
  }

  @override

  Widget buildResults(BuildContext context) {      //los resultados cuando la persona presiona ENTER
      return buildResultsAndSuggestions();
  }

  @override
       //la persona esta escribiendo y va trayendo la data como el buscador de google
  Widget buildSuggestions(BuildContext context) {   //siempre que estoy en un metodo build puedo utilizar algun gestor de estado
      _onQueryChanged(query); //siempre que toque una tecla va a entrar a esta funcion
      return buildResultsAndSuggestions();
    
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({super.key, required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context,movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(  //cuando estoy dentro de un row necesito un tamaño fijo
          children: [
            //image
            SizedBox(
                width: size.width * 0.2, //mostramos un 20% de la pantalla, para mostrar la iamgen
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network( //muestro las peliculas
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                  ), 
                ),
            ),
              SizedBox(width: 10,),
            //descripcion
            SizedBox(
              width: size.width * 0.7, //agarro el 70% de la pantalla
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(movie.title, style: textStyles.titleMedium,),
                    (movie.overview.length > 100)
                    ? Text('${movie.overview.substring(0,100)}...') //si tiene mas de 100 caracateres que me muestre con los ...
                    : Text(movie.overview),  //y si tiene menos me lo muestra completo
    
                    Row(
                      children: [
                        Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                        const SizedBox(width: 5,),
                        Text(
                          HumanFormats.number(movie.voteAverage, 1), 
                          style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900 ) ,
                          ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
       ),
    );
  }
}