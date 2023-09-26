
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final approuter = GoRouter(
  initialLocation: '/home/0',
  routes: [
      GoRoute(  //el go router es el sistema de navegacion entre paginas, solo se utiliza para eso
        path: '/home/:page',  //recibo el home y la pagina
        name: HomeScreen.name,
        builder: (context, state) {
          final pageIndex = state.pathParameters['page'] ?? '0';  //si no tengo el string, entonces obtengo STRING 0
         
          return HomeScreen(pageIndex: int.parse(pageIndex) ,);  //lo convierto a un entero
        },
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

  GoRoute(
    path: '/',
    redirect:  (_, __) => '/home/0',  //poner el _ significa que no necesito ninguno de esos 2 argumentos, en este caso es el context y state
  ),

  



  ]
);

