import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'movie_posterLink.dart';


class MovieMasonry extends StatefulWidget {

  final List<Movie> movies; //me traigo el listado de movies
  final VoidCallback? loadNextPage; 

  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => MovieMasonryState();
}

class MovieMasonryState extends State<MovieMasonry> {

  final scrollcontroller = ScrollController();
  

  //init state
  @override
  void initState() {
    super.initState();
    
    scrollcontroller.addListener(() async {
      if(widget.loadNextPage == null) return;  //si ya cargo no retorno nada

    if((scrollcontroller.position.pixels + 100) >= scrollcontroller.position.maxScrollExtent){
       await const Duration(milliseconds: 100); //esperamos 100milisegundos al cargar
       widget.loadNextPage!();  //cargamos la siguienta pagina
    }
  });
  }

  //init dispose
  @override
  void dispose() {
    scrollcontroller.dispose(); 
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        padding: const EdgeInsets.only(top: 50) ,  //dejo lugar hacia arriba, para que pueda hacer el scroll, sino no puedo
        controller: scrollcontroller,
         crossAxisCount: 3,
         mainAxisSpacing: 10,
         crossAxisSpacing: 10,
         itemCount: widget.movies.length,  //cuando estoy dentro del statefulwidget debo poner widget al principio
         itemBuilder: (context, index) {
          if(index == 1){
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink(movie: widget.movies[index])
              ],
            );
          }
           return MoviePosterLink(movie: widget.movies[index]);
         },
      ),
    );
  }
}