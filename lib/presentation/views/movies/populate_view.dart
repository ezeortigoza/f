import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopulateView extends ConsumerStatefulWidget {
  const PopulateView({super.key});

  @override
  PopulateViewState createState() => PopulateViewState();
}

class PopulateViewState extends ConsumerState<PopulateView> with AutomaticKeepAliveClientMixin {  //este mixin nos sirve para saber cuando mantener vivo mi estado y cuando no...

  

  @override
  Widget build(BuildContext context) {
    super.build(context);  //si o si debemos llamar el superbuild

    final popularMovies = ref.watch(popularMoviesProvider);

    if ( popularMovies.isEmpty ) { //si esta vacio regresamos un circular
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: () => ref.watch(popularMoviesProvider.notifier).loadNextPage() ,
        movies: popularMovies,
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;  //por defecto lo queremos mantener vivo
}