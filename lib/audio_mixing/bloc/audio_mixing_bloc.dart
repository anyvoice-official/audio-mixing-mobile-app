import 'dart:async';
import 'dart:io';

import 'package:audio_mixing_mobile_app/audio_mixing/bloc/audio_mixing_event.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/bloc/audio_mixing_state.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/repository/audio_mixing_repository.dart';
import 'package:audio_mixing_mobile_app/config/audio_config.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sounds/sounds.dart';

class AudioMixingBloc extends Bloc<AudioMixingEvent, AudioMixingState> {
  AudioMixingBloc() {
    init();
  }
	
  Future<void> init() async {
    _tempDirRecord = await getApplicationDocumentsDirectory();
    File('${_tempDirRecord.path}/${AudioConfig.RECORDING_FILENAME}').create(recursive: true);

		_playerCompleteSubscription = _player.onPlayerCompletion.listen((event) {
			_onComlete();
		});
  }

	final AudioMixingRepository _repository = AudioMixingRepository();

	final SoundRecorder _recorder = SoundRecorder();
	final AudioPlayer _player = AudioPlayer();
	StreamSubscription _playerCompleteSubscription;

	Directory _tempDirRecord;
	Timer _timer;


  @override
  AudioMixingState get initialState => AudioMixingState();

  @override
  Stream<AudioMixingState> mapEventToState(AudioMixingEvent event) async* {
		if (event is StartRecordingAudioEvent) {
			yield* _mapStartRecordingAudioToState(event, state);
		}

		if (event is UpdateTimerEvent) {
			yield* _updateTimer(event, state);
		}

		if (event is StopRecordingAudioEvent) {
			yield* _mapStopRecordingAudioToState(event, state);
		}

		if (event is StartPlayingAudioFromLocalFileEvent) {
			yield* _mapStartPlayingAudioFromLocalFileToState(event, state);
		}

		if (event is StartPlayingAudioFromNetworkEvent) {
			yield* _mapStartPlayingAudioFromNetworkToState(event, state);
		}
		
		if (event is StopPlayingAudioEvent) {
			yield* _mapStopPlayingAudioToState(event, state);
		}

		if (event is SubmittedEvent) {
			yield* _mapSubmittedToState(event, state);
		}
  }

	Stream<AudioMixingState> _mapSubmittedToState(SubmittedEvent event, AudioMixingState state) async* {
		try {
			final response = await _repository.audioMixing(File('${_tempDirRecord.path}/${AudioConfig.RECORDING_FILENAME}'));

			if (response?.audioLink != null) {
				yield state.copyWith(status: AudioMixingStatus.successSubmitted, audioLink: response.audioLink);
			} else {
				yield state.copyWith(status: AudioMixingStatus.errorSubmitted);
			}
		} on DioError catch (ex) {
			yield state.copyWith(status: AudioMixingStatus.errorSubmitted);
			rethrow;
		}
	}

	Stream<AudioMixingState> _mapStartRecordingAudioToState(StartRecordingAudioEvent event, AudioMixingState state) async* {
		try {
      PermissionStatus status = await Permission.microphone.request();
      PermissionStatus statusStorage = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        throw Exception("Microphone permission not granted");
      }

      if (statusStorage != PermissionStatus.granted) {
        throw Exception("Storage permission not granted");
      }

			File outputFile = File('${_tempDirRecord.path}/${AudioConfig.RECORDING_FILENAME}');
      final recording = Track.fromFile(
        outputFile.path,
        mediaFormat: AdtsAacMediaFormat(
          bitRate: 96000,
          sampleRate: 44100,
          numChannels: 2,
        ),
      );

			_recorder.record(
        recording,
      );

			yield state.copyWith(status: AudioMixingStatus.recording);
			_timer = Timer.periodic(
				Duration(milliseconds: 1000), 
				(timer) => add(UpdateTimerEvent(timer.tick)),
			);
		} on Exception {
			rethrow;
		}
	}

	Stream<AudioMixingState> _mapStopRecordingAudioToState(StopRecordingAudioEvent event, AudioMixingState state) async* {
		try {
			yield state.copyWith(status: AudioMixingStatus.successRecording);

			_timer?.cancel();
			await _recorder.stop();
		} on Exception {
			rethrow;
		}
	}

	Stream<AudioMixingState> _mapStartPlayingAudioFromLocalFileToState(
		StartPlayingAudioFromLocalFileEvent event, 
		AudioMixingState state
	) async* {
		_player.play('${_tempDirRecord.path}/${AudioConfig.RECORDING_FILENAME}', isLocal: true);
		yield state.copyWith(status: AudioMixingStatus.playing);
	}

	Stream<AudioMixingState> _mapStartPlayingAudioFromNetworkToState(
		StartPlayingAudioFromNetworkEvent event, 
		AudioMixingState state
	) async* {
		_player.play(event.audioLink);
		yield state.copyWith(status: AudioMixingStatus.playing);
	}

	Stream<AudioMixingState> _mapStopPlayingAudioToState(StopPlayingAudioEvent event, AudioMixingState state) async* {
		_player.stop();
		yield state.copyWith(status: AudioMixingStatus.successRecording);
	}

  Stream<AudioMixingState> _onComlete() async* {
    add(StopPlayingAudioEvent());
  }

	Stream<AudioMixingState> _updateTimer(UpdateTimerEvent event, AudioMixingState state) async* {
		yield state.copyWith(timer: event.timer);
	}

  @override
  Future<void> close() {
    _recorder?.release();
		_player?.release();
    _timer?.cancel();
    return super.close();
  }
}