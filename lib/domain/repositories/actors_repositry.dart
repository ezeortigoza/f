import 'package:cinemapedia/domain/entities/actors.dart';

abstract class ActorsRepostory {
  Future<List<Actors>> getActorByMovie(String movieId);
}