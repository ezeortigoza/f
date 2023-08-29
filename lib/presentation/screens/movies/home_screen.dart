import 'package:cinemapedia/config/constants/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen'; //es el nombre que le asigno a este componente


  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text( Enviroment.movieDbKey),  //utilizo una variable static para poder traerlo
      )
    );
  }
}