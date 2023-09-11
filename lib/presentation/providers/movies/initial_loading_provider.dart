import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
    final step1 = ref.watch(nowPlayingMovieProvider).isEmpty; //con el isEmpty se queda sin ningun dato, si cada uno de estos estan vacios ahora tenemos un monton de booleanos
    final step2 = ref.watch(popularMoviesProvider).isEmpty;
    final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
    final step4 = ref.watch(upComingMoviesProvider).isEmpty;

    //si cualquiera de todos estos estan vacios, entonces estoy cargando... 
    //cuando todos ya tienen un valor ahi retorno FALSO
    if(step1 && step2 && step3 && step4) return true;

    return false; //se regresa falso cuando ya se cargo todo 
});