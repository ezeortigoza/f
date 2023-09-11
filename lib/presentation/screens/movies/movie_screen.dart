import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
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

  const _MovieDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
          
      ),
        //Generos de la pelicula
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
       ),

        //TODO: Mostrar actoresC con listView
        _ActorsByMovie(movieId:movie.id.toString()),
        const SizedBox(height: 50,),
      
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
            padding: EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  
                  duration: Duration(seconds: 1),
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
                   style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), //el textoverflow pone puntos seguidos por si hay mucho texto
                ),
              ],
            ),
          );
        },
        ),
    );
  }
}


class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie; 

  const _CustomSliverAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;  //tengo las dimensiones del dispostivo fisicamente

    return SliverAppBar(
      
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, //quiero el 70% de la pantalla
      foregroundColor: Colors.white ,
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

                const SizedBox.expand(  //hacemos el gradiente en la foto para que se pueda leer el titulo
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.7, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black87
                        ]
                      )
                    )
                    
                    
                    ),
                ),

                   const SizedBox.expand(  //hacemos el gradiente arriba a la izq para que se pueda ver la flecha
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                      
                        stops: [0.0, 0.3],
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ]
                      )
                    )
                    
                    
                  ),
            )
          ],
        ),  
      ),
    );
  }
}