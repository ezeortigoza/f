import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen'; //el nombre lo pongo para poder llegar rapidamente a la pantalla
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {  //dentro de todo el consumer, tenemos referencia al REF

  @override
  void initState() {  //esto me ayuda a saber cuando estoy cargando y cuando termino de cargar, y hacer un cache local para que no haga devuelta una nueva peticion al cargar
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId); //ESTA LINEA DE CODIGO hace la peticion HTTP, pongo widget porque estoy dentro del CONSUMERSTATE
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId); //ESTA LINEA DE CODIGO hace la peticion HTTP, pongo widget porque estoy dentro del CONSUMERSTATE

  }


  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];  //esto que tengo aca es un MAPA, lo que quiero traer es la pelicula, pongo widget.movieId y me trae las peliculas

    if( movie == null){
      return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2,),));  //si es null, va a mostrar el circulo de carga, agrego el scaffold con body para que no quede la pantalla en negro
    }

    return Scaffold(
       body: CustomScrollView(
        physics: const ClampingScrollPhysics(),  //para que IOS no haga el efecto rebote
        slivers: [
            _CustomSliverAppBar(movie: movie,),
            SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie,),
              childCount: 1  //solo voy a tener un elemento para mostrar... Sino me lo repite infinita veces
            ) )
        ],
       ),
    );
  }
}

  class _MovieDetails extends StatelessWidget {

    final Movie movie;

  const _MovieDetails({ required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
          //titulo, overview y raiting
          _TitleAndOverview(movie: movie, size: size, textStyles: textStyles),

          //generos de la pelicula
          _Generes(movie: movie),



          //actores de la pelicula
        _ActorsByMovie(movieId:movie.id.toString()),
        //const SizedBox(height: 50,),



        //Videos de pelicula (si tiene)
        VideosFromMovie(movieId: movie.id),



        //peliculas similares
        SimilarMovies(movieId:  movie.id),

      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {

  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if(actorsByMovie[movieId] == null){ //si estan cargando los actores entonces muestro el circulo
        return const Center(child:  CircularProgressIndicator(strokeWidth: 2,));
    }

    final actors = actorsByMovie[movieId]!; //con el "!" significa que siempre los tengo
    return SizedBox(  //creo la forma en que se van a ver los actores
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  
                  duration: const Duration(seconds: 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath!,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //Nombre
                const SizedBox(height: 5,),

                Text(actor.name,maxLines:2 ,), //nombre del actor/actriz
                Text(
                  actor.character ?? '',  //nombre del personaje de la pelicula
                   maxLines: 2, 
                   style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), //el textoverflow pone puntos seguidos por si hay mucho texto
                ),
              ],
            ),
          );
        },
        ),
    );
  }
}

  //vamos a hacer TRUE o FALSE para saber si tiene que estar con color rojo el corazon cuando esta en favorito o cuando no lo esta
   final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {  //esto me sirve para traer alguna tarea asincrona, el future o sus valores, el family me deja mandar argumento para saber si ese ID esta en la DB, el autodispose confirma en si esta en favorito o no la pelicula
      
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);  //estamos pendiente del DATASOURCE

      return localStorageRepository.isMovieFavorite(movieId); //si esta en favoritos
   }); 


  class _Generes extends StatelessWidget {
    final Movie movie;
  const _Generes({
     required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return  //Generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genero) => Container(  //me traigo el genero y lo muestro por debajo
                 margin: const EdgeInsets.only(right: 10),
                 child: Chip(
                  label: Text( genero ) ,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
              ) )
            ],
          ),
       );
  }
}





class _CustomSliverAppBar extends ConsumerWidget {  //puedo utilizar el REF, en el consumerWidget

  final Movie movie; 

  const _CustomSliverAppBar({ required this.movie});

  @override
  Widget build(BuildContext context, ref) {


    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;  //tengo las dimensiones del dispostivo fisicamente

    return SliverAppBar(
      
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, //quiero el 70% de la pantalla
      foregroundColor: Colors.white ,
      actions: [
        IconButton(
          onPressed: ()async  {
            //await ref.watch(localStorageRepositoryProvider)  //pongo el await para que se espere a la hora de la peticion y asi poder cambiar el icono
            //.toggleFavorite(movie); //el ref solo funciona con el consumerWidget, mando a llamar la pelicula
            await ref.read(favoritesMoviesProvider.notifier) //pongo el await para que se espere a la hora de la peticion y asi poder cambiar el icono
            .toggleFavorite(movie); 
            //await Future.delayed(const Duration(milliseconds: 100));
            ref.invalidate(isFavoriteProvider(movie.id)); //esto sirve para que vuelva hacer la peticion y confirme, ahora si se puede ver el cambio en tiempo real cuanfdo le doy fav
          }, 
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            data: (isFavorite) => isFavorite
            ? const Icon(Icons.favorite_rounded, color: Colors.red,) //si esta en fav el icono en ROJO
            : const Icon(Icons.favorite_border), //sino el icono sin color
            error: (_,__) => throw UnimplementedError(), 
           ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(  //espacio felxible de nuestro sliverappbar
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          centerTitle: false,
          /* title: Text(
            movie.title,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.start,
        ), */
          background: Stack(  //nos permite colocar widgets uno encima de otros
            children: [
                SizedBox.expand(  //crea el cuadro como es de grande el padre... en este caso su padre seria sliverappbar
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress != null) return const SizedBox(); //si la imagen no tiene nada que me regrese un sizedbox es decir NADA
                      return FadeIn(child: child); //caso contrario regreso mi imagen de la pelicula, lo envuelvo en un FADEIN para que aparezca la foto, y no se muestre de golpe
                    },
                  ),
                ),

                const CustomGradient(
                  colors: [Colors.black54,Colors.transparent] , 
                  stops: [0.0, 0.2], 
                  begin:  Alignment.topRight,
                  end: Alignment.bottomLeft, 
                 ),

                 const CustomGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.8,1.0],
                  colors: [Colors.transparent,Colors.black54], 
                  ),


                const  CustomGradient( //hacemos el gradiente arriba a la izq para que se pueda ver la flecha
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                         stops: [0.0, 0.3], 
                         begin: Alignment.topLeft
                      )
          ],
        ),  
      ),
    );
  }
}

class CustomGradient extends StatelessWidget {

  final List<Color> colors;
  final List<double> stops;
  final AlignmentGeometry end;
  final AlignmentGeometry begin;

  const CustomGradient({
    super.key, 
    required this.colors, 
    required this.stops,
    this.end = Alignment.centerRight, 
    this.begin = Alignment.centerLeft
    });

  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
           gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors:colors
          )
        ) 
      ),
    );
  }
}





class _TitleAndOverview extends StatelessWidget {

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  const _TitleAndOverview({
     required this.movie, 
     required this.size, 
     required this.textStyles
  });

  @override
  Widget build(BuildContext context) {
     return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath, width: size.width * 0.3,), //esto seria el 30% de la pantalla
                
              ),
              const SizedBox(width: 10,),
               

              //descripcion
              SizedBox(
                width: (size.width - 40) * 0.7, //se le resta 40 pixeles
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,style: textStyles.titleLarge,),
                    Text(movie.overview, style: textStyles.bodyLarge,)
                  ],
                ),
              )

            ],
          ),
          
      );
  }
}