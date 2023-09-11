import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage; //esto es para el infinit scroll, pero es opcional una vez que cargo todas las peliculas no quiero que cargue mas nada

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subtitle, 
    this.loadNextPage
    });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController(); //esto es para definir en que punto estoy del video por ejemplo o darle pausa etc
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {  //siempre que se agrega un listener se agrega el dispose
       if(widget.loadNextPage == null) return;

       if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
         widget.loadNextPage!(); //agrego el ! porque yo se que no va a ser NULA
       }

    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, //pongo 350 de height para poder mostrar los titulos y demas
      child:Column(
        children: [
             if(widget.title != null || widget.subtitle != null) //basicamente si alguno de los 2 es distinto de NULL renderizo su valor
            _Title(title: widget.title, subTitle: widget.subtitle,),

            Expanded( //necesito que el listVIew tenga un tamaño especifico
              child: ListView.builder( //si el widget es muy pesado es decir muchos widgets es mejor el builder
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal, //para que haga el scroll horizontal
                physics: const BouncingScrollPhysics(), //para que sea igual el rebote en IOS y ANDROID
                itemBuilder: (context, index) {
                   return FadeInRight(child: _Slide(movie: widget.movies[index])); //devolvemos las peliculas una por una, cuando agregamos el fadeinright van apareciendo a medida que cargan hacia la derecha
                }, 
            )
          )
        ],
      ),
    );
  }
}


class _Slide extends StatelessWidget {

  final Movie movie;
  const _Slide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8), //para que haya una separacion en cada pelicula
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //todos los hijos alineados al inicio
        children: [
          SizedBox( //aca puedo agregar las imagenes y agregarle banda de cosas
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover, //para que todas las imagenes tengan el mismo tamaño
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return Center(child: const CircularProgressIndicator(strokeWidth: 2)); //lo envolvi en un center para que se vea centrado cuando aparece el icono de carga
                  }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'), //esto me sirve para dar click y llevar a la pelicula
                    child: FadeIn(child: child),  //agregamos un poco de animacion a la entrada con el paquete de animate_do
                    );
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          //Title

          SizedBox(
            width: 150,
            child: Text(
              movie.title, //mostramos el titulo
              maxLines: 2, //para que se acorte el titulo
              style: textStyles.titleSmall,
            ),
          ),

          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,), //el shade son alteraciones de ese color
                SizedBox(width: 3,), //separar un poco
                Text('${movie.voteAverage}', style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade800),),  //para que pueda tener en color amarillo , se utiliza copywith porque me deja copiar toda la informacion de bodymedium
                const SizedBox(width: 10,),
                const Spacer(), //para poder agregar el spacer en un ROW debo colocar un sizedBox y ponerle un ancho fijo al row y no dejarlo INFINITO
                Text(HumanFormats.number(movie.popularity),style: textStyles.bodySmall) //llamo la clase y la funcion y agrego mi movie.popularity para que aparezca con el simbolo "m" o "k"
                
              ],
            ),
          )

        ],
      )
    );
  }
}


class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({
    this.title, 
    this.subTitle
    });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 15),
      //color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
          Text(title!,style: titleStyle),  //el title! significa que nunca va a ser nulo 

          const Spacer(),  //para que agarre todo el ancho completo

          if(subTitle != null)
          FilledButton.tonal(
            style: const ButtonStyle(visualDensity: VisualDensity.compact), //achicamos mas el boton
            onPressed: () {}, 
            child: Text(subTitle!)
          )
        ],
      ),
    );
  }
}