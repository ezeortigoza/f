import 'package:cinemapedia/domain/entities/actors.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier,Map<String,List<Actors>>>((ref) {
    final actorsRepository = ref.watch(actorsRepositoryPovider); //llamo al actorsRepository, es el corazon de todo lo que estamos haciendo
    return ActorsByMovieNotifier(getActor: actorsRepository.getActorByMovie);  //llamo a mi class ActorsByMovieNotifier, lo mando para que me busque por ID
});





typedef GetActors = Future<List<Actors>>Function(String movieId);


class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actors>>> {  //MANTENER en cache todas las peliculas que ya haya consultado

  final GetActors getActor;

  ActorsByMovieNotifier({required this.getActor}): super({});

  Future<void> loadActors(String actorId) async {
    if(state[actorId] != null) return;  //si tengo mi estado con ese ID con esa pelicula cargada no devuelvo nada
    print('Realizando peticion http');
    final List<Actors> actors = await getActor(actorId); //mando a llamar mi funcion

    state = {...state, actorId: actors}; //clono todo el estado anterior con el operador SPREAD , luego va aapuntar al movieId (si la movie existe), sino va largar una excepcion
  }

}