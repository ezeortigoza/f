import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key}); //el super KEY es para mantener la referencia a este WIDGET

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMovieProvider.notifier).loadNextPage(); //pongo READ porque estoy dentro de un metodo o funcion, este loadNextPage() va a llamar a la siguiente pagina
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return const FullScreenLoader();  //si esta en true regreso el fullScreenLoader()

    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPLayingMovies = ref.watch(nowPlayingMovieProvider); //mi listado de peliculas, las traigo
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);


    return CustomScrollView( //esto lo agrego para poder hacer scroll hacia abajo, cuando voy agregando mas childrens SingleChildScrollView(), agregue el CustomScrollView() esto me sirve para poder implementar el appbar y que quede como fixed cuando hago scroll hacia abajo
      slivers: [  //esto seria como un child

        const SliverAppBar( //va a ser un appBar que va a estar ahi, pero funciona como fixed 
          floating: true, //hago scroll y subo, el appbar aparece
          flexibleSpace: FlexibleSpaceBar( //este widget me permite añadir mi appbar creado
            title: CustomAppBar(), //agrego mi appbar
            centerTitle: true, //agrego el titulo al centro
          ),
        ), 
        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
      return Column(
        children: [
    
          //CustomAppBar(), //esto srive como el appBar, pero nos da algunas funcionalidades que appBar no la da
    
          MoviesSlideShow(movies: slideShowMovies),
          
          MovieHorizontalListview(
            movies: nowPLayingMovies,
            title: 'En cines',
            subtitle: 'Lunes 20',
            loadNextPage: () {
              ref.read(nowPlayingMovieProvider.notifier).loadNextPage();  //el read se utiliza dentro de funciones o callbacks
            }
            ),

            MovieHorizontalListview(
            movies: upComingMovies,
            title: 'Proximamente',
            subtitle: 'En este mes',
            loadNextPage: () {
              ref.read(upComingMoviesProvider.notifier).loadNextPage();  //el read se utiliza dentro de funciones o callbacks
            }
            ),

            /*  MovieHorizontalListview(
            movies: popularMovies,
            title: 'Populares',
            //subtitle: 'En este mes',
            loadNextPage: () {
              ref.read(popularMoviesProvider.notifier).loadNextPage();  //el read se utiliza dentro de funciones o callbacks
            }
            ), */


               MovieHorizontalListview(
            movies: topRatedMovies,
            title: 'Mejor calificadas',
            subtitle: 'Desde siempre',
            loadNextPage: () {
              ref.read(topRatedMoviesProvider.notifier).loadNextPage();  //el read se utiliza dentro de funciones o callbacks
            }
            ),

            const SizedBox(height: 30,),
    
    
            

      /*   Expanded(  //el expanded sirve para epandir todo lo posible es decir tiene un alto y un ancho FIJO
          child: ListView.builder(
             itemCount: nowPLayingMovies.length,
             itemBuilder: (context, index) {
             final movie = nowPLayingMovies[index];
             return ListTile(
             title: Text(movie.title),
              
            );
          },
          ),
        ) */
    
    
        ],
      );
       },childCount: 1) //agrego el childcount para que solo se muestre una sola vez, todo lo que agregue, sino lo muestra infinitas veces
        )
      ]
    );

  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}