import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';




class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});
  
  @override
  FavoritesViewState createState() => FavoritesViewState(); 

}

  class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin {
   
   bool isLastPage = false;
   bool isLoading = false;

  @override
  void initState() {
     super.initState();
    loadNextPage();
  }

  Future loadNextPage() async {
    if(isLoading || isLastPage) return; //si estoy cargand no hace falta cargar entonces me salgo

    isLoading = true;
    
    final movies = await ref.read(favoritesMoviesProvider.notifier).loadNextPage(); //estas son todas las peliculas que tengo
    isLoading = false;  //ya deje de cargar
   
    if( movies.isEmpty){ //si esta vacio
        isLastPage = true; //recargamos las siguientes
    }
    

  }

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
 
    final favoritesView = ref.watch(favoritesMoviesProvider).values.toList(); //convierto todos los valores en una lista

   if(favoritesView.isEmpty){
    final colors = Theme.of(context).colorScheme;
     return  Center(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary ,),
            Text('Upss', style: TextStyle(fontSize: 30, color: colors.primary)),
            const Text('No tienes peliculas favoritas :(', style: TextStyle(fontSize: 20, color: Colors.white),),

            const SizedBox(height: 20,),

            FadeInLeft(
              child: FilledButton.tonal(
              onPressed: () => context.go('/home/0'), 
              child: const Text('Empieza a buscar')
              ),
            ),
        ],
    )); 
   }
       return Scaffold(
      body: MovieMasonry(
      loadNextPage: loadNextPage,
      movies: favoritesView,
    ),
    
  );

   
 }
 
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
/* 
  Widget build(BuildContext context, Widget ref) {
    return const Placeholder();
  } */