import 'package:cinemapedia/presentation/views/movies/home_view.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {

  static const name = 'home-screen'; //es el nombre que le asigno a este componente
  final int pageIndex;  //que opcion del TAB quiere mostrar y que vista

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true
    );
  }
  


  final viewRoutes = const <Widget>[
    HomeView(),
    PopulateView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(pageController.hasClients){
      pageController.animateToPage(
         widget.pageIndex,
         duration: const Duration(milliseconds: 400), 
         curve: Curves.easeInOut
      );
    }

    return  Scaffold(
      /* body: IndexedStack(  //el indexStack mantiene el scroll, puedo ir a favoritos y me deja el scroll donde lo habia dejado anteriormente, es decir mantiene el ESTADO
        index: widget.pageIndex, //me muestra el index que quiero mostrar
        children: viewRoutes,  //esta es toda la lista de widget que tengo para mostrar
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: widget.pageIndex,), */

      body: PageView(
        physics: const NeverScrollableScrollPhysics(), //esto evita el rebote
        controller: pageController,
        children: viewRoutes,
      ),
       bottomNavigationBar: CustomBottomNavigation(currentIndex: widget.pageIndex,),
    );
}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
