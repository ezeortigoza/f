

import 'package:cinemapedia/config/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/domain/entities/actors.dart';

class ActorMapper{
  static Actors casToEntity(Cast cast) => Actors(
    id: cast.id , 
    name: cast.name, 
    profilePath: cast.profilePath != null  //foto del actor/actriz
    ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
    : 'https://www.circumcisionpro.co.uk/wp-content/uploads/2021/05/avatar-profile-picture.jpg', 
    character: cast.character
  );
}