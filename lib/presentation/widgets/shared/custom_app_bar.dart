import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CustomAppBar extends ConsumerWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    
    final colors = Theme.of(context).colorScheme; //traigo mis colores globales
    final titleStyle = Theme.of(context).textTheme.titleMedium;  //traigo el estilo del titulo 

    return SafeArea( //esta muy arriba y el NOTCH va estorbar 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,  //dale tdoo el ancho que puedas
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary,),
              const SizedBox(width: 5,),
              Text('Cinemapedia', style: titleStyle,),
      
              const Spacer() , //es como que toma todo el espacio horizontal como un flex layout, y lo tira hacia la derecha el boton
      
              IconButton(
                onPressed: () {

                  final searchedMovies = ref.read(searchedMoviesProvider); //Esto lo pude traer porque lo converti en un consumer widget, llame mi searchedMoviesProvider
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>( //lo mando opcional porque tal vez la persona quiera acceder o no a la pelicula
                  query: searchQuery,
                    context: context , //el context es toda la info de mi app
                    delegate: SearchMovieDelegate(  //este es el encargado de trabajar la busqueda
                      initialMovies: searchedMovies ,  //esto hace que ya las peliculas queden almacenadas en memoria
                      searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery //traigo la referencia de searchMovies
                  )
                ).then((movie) {  //es un future dentro de la funcion showSearch, que trae la pelicula opcional
                    if( movie == null ) return;  //si es null no retornamos nada


                    context.push('/home/0/movie/${movie.id}');  //navegamos hacia la pagina dirigida de cada pelicula cuando el usuario da click
                });
                }, 
                icon: Icon(Icons.search, color: colors.primary)
              ),
      
            ],
          ),
        ),
        )
      );
  }
}