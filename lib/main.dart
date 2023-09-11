import 'package:flutter/material.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env'); //define el .env y pueda utilizarse de manera global
  runApp(
    const ProviderScope(child: MainApp())  //Esto va a ayudar para poder llamar a todos los provaiders de riverpod
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router( 
      routerConfig: approuter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(), //llamamos la clase con su respectiva funcion para traer el TEMA y material 3
      
    );
  }
}
