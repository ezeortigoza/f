import 'package:flutter/material.dart';


class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
     final messages = <String>[
    'Cargando peliculas',
    'Comprando palomitas de maiz',
    'Cargando populares',
    'Llamando a mi novia',
    'Esto esta tardando mas de lo esperado',
  ];
    return Stream.periodic(const Duration(milliseconds: 1200),(step) { //utilizo stream ya que para construir utilice el streambuilder
        return messages[step]; //retorno los mensajes con los miliseconds esperados
    }, ).take(messages.length); //cancelo el periodo con el message.length
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Text('Espere por favor'),
            const SizedBox(height: 10,),
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 10,),
            StreamBuilder( //construye basado en un STREAM
              stream: getLoadingMessages() ,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return const Text('Cargando...'); //si no tiene DATA que me muestre el mensaje cargando 

                return Text(snapshot.data!); //y sino que me muestre los mensajes...
              },
            )
        ],
      ),
    );
  }
}