import 'package:cinemapedia/domain/entities/actors.dart';

abstract class ActorsDatasource {
  Future<List<Actors>> getActorByMovie(String movieId);
}