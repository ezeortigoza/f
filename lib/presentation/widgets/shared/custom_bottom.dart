import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  int selected = 0;  //creo esta variable para poder interactuar con cada index

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(  //minimo se necesitan 2 botones
    //type: BottomNavigationBarType.shifting, //esto me sirve para cambiar el color a la barra de navegacion depende que color tenga mi boton cambia el color de la barra
      currentIndex: selected, //deja seleccionada la opcion con el hover , cuando le doy click
      onTap: (value) {
        setState(() {
           selected = value;  //esto me ayuda a saber en que indice se encuentra mi value, cuando le doy click
        });
      },
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
}