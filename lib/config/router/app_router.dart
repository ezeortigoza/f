
import 'package:cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final approuter = GoRouter(
  initialLocation: '/',
  routes: [
      GoRoute(  //el go router es el sistema de navegacion entre paginas, solo se utiliza para eso
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
        routes: [   //esto me sirve para volver al home es decir que aparezca la flecha para volver
        GoRoute(
        path: 'movie/:id',  //sin el primer SLASH porque el padre me lo esta dando
        name: MovieScreen.name,
        builder: (context, state) {
          final movieId = state.pathParameters['id'] ?? 'no-id';  //los queryparameters siempre son string y nos sirve para buscar ese ID determinado

          return MovieScreen(movieId: movieId ,);
     }
  ),
        ]
  ),

  



  ]
);

