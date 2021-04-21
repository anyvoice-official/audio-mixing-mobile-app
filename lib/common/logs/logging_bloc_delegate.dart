import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_mixing_mobile_app/common/logs/logger.dart' as developer;

class LoggingBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    developer.log('$transition', name: bloc.runtimeType.toString());
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object event) {
    super.onEvent(bloc, event);
    developer.log('$event', name: bloc.runtimeType.toString());
  }

  @override
  void onError(Bloc<dynamic, dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log('$error', name: bloc.runtimeType.toString(), error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}