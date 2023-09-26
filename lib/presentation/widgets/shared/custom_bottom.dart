import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CustomBottomNavigation extends StatelessWidget {
   
  final int currentIndex;  //creo esta variable para poder interactuar con cada index

  const CustomBottomNavigation({super.key, required this.currentIndex});
  

  void onItemTapped(BuildContext context, int index){
     switch(index){
      case 0:
       context.go('/home/0');
       break;
       case 1:
       context.go('/home/1');
       break;
       case 2:
       context.go('/home/2');
       break;
      
     }

  }

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(  //minimo se necesitan 2 botones
    //type: BottomNavigationBarType.shifting, //esto me sirve para cambiar el color a la barra de navegacion depende que color tenga mi boton cambia el color de la barra
      currentIndex: currentIndex, //deja seleccionada la opcion con el hover , cuando le doy click
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      selectedItemColor: colors.primary,  //esto lo necesito para que me seleccione el hover con el color del boton cuando esta activo
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          //activeIcon: Icon(Icons.accessibility_rounded), //esto se utiliza cuando esta activo el boton, toco el boton y me cambia el icono
          label: 'Inicio'
          
      ),

       BottomNavigationBarItem(
         icon: Icon(Icons.thumbs_up_down_outlined),
        label: 'Populares'
      ),

      BottomNavigationBarItem(
         icon: Icon(Icons.favorite_outline),
        label: 'Favoritos'
      ),
      ]
    );
  }


}



  int selected = 0;  //creo esta variable para poder interactuar con cada index

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(  //minimo se necesitan 2 botones
    //type: BottomNavigationBarType.shifting, //esto me sirve para cambiar el color a la barra de navegacion depende que color tenga mi boton cambia el color de la barra
      currentIndex: selected, //deja seleccionada la opcion con el hover , cuando le doy click
       /* (value) {
        setState(() {
           selected = value;  //esto me ayuda a saber en que indice se encuentra mi value, cuando le doy click
        });
      }, */
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          //activeIcon: Icon(Icons.accessibility_rounded), //esto se utiliza cuando esta activo el boton, toco el boton y me cambia el icono
          label: 'Inicio'
          
      ),

       BottomNavigationBarItem(
         icon: Icon(Icons.label_outline),
        label: 'Categorias'
      ),

      BottomNavigationBarItem(
         icon: Icon(Icons.favorite_outline),
        label: 'Favoritos'
      ),
      ]
    );
  }
