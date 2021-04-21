import 'dart:async';
import 'dart:developer';

import 'package:audio_mixing_mobile_app/app.dart';
import 'package:audio_mixing_mobile_app/common/logs/logging_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = LoggingBlocDelegate();

  await runZonedGuarded<Future<Null>>(() async {
		runApp(App());
	}, (error, stackTrace) async {
    log('$error', name: 'Main', error: error, stackTrace: stackTrace);
  });
}
