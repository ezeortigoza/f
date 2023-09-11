import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';


class MoviesSlideShow extends StatelessWidget {

  final List<Movie> movies;

  const MoviesSlideShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity, //agarra todo el ancho 
       child: Swiper( //este seria el slide por asi decirlo.. el carrusel, es muy parecido al widget PAGEVIEW
        pagination: SwiperPagination( //este es para agregar los puntos debajo del carrusel
            margin: const EdgeInsets.only(top: 0), //para bajar todo lo que pueda y que queden separados los puntos del carrusel
            builder: DotSwiperPaginationBuilder( //es para personalizar los puntos, lo construimos nosotros
              activeColor: colors.primary, //el activo
              color: colors.secondary //el color de fondo
            )
        ),
        viewportFraction: 0.8, //puedo ver el slide anterior y el que sigue
        scale: 0.9, //para verlo mas pequeño
        autoplay: true, //quiero que se mueve automaticamente
        itemCount: movies.length, //traemos la cantidad de peliculas
        itemBuilder:(context, index) => _Slide(movie: movies[index]), //devolvemos uno por uno las peliculas
      ), 
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final decoration = BoxDecoration(  //decoramos la caja por dentro
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10), //es para donde quiero mover la sombras si para el eje X o eje Y
        )
      ]
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30), //dejo espacios para poder agregar los puntos abajo 
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect( //el clip es para colocar border redondeados
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,  //ahi agregamos las imagenes de las peliculas
            fit: BoxFit.cover,  //para darle el espacio que le estamos asignando
            loadingBuilder: (context, child, loadingProgress) {
              if ( loadingProgress != null){  //es para que muestre medio gris black antes de que carguen las imagenes
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12)
                );
              }
              return FadeIn(child: child);  //la imagen entra con suavidad, agregando el fade in , es un paquete externo llamado animate_do
            },
          )
          )  
        ), 
    );
  }
}