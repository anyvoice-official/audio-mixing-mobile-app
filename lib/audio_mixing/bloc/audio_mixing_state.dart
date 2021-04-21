import 'package:audio_mixing_mobile_app/audio_mixing/models/audio_mixing.dart';
import 'package:equatable/equatable.dart';

enum AudioMixingStatus {
	init,
	recording,
	successRecording,
	submitted,
	submittedInProgress,
	successSubmitted,
	errorSubmitted,
	playing
}

class AudioMixingState extends Equatable {
	const AudioMixingState({
		this.selectedEffectType = EffectType.NONE, 
		this.status = AudioMixingStatus.init, 
		this.audioLink,
		this.timer = 0
	});

	final EffectType selectedEffectType;
	final AudioMixingStatus status;
	final	String audioLink;
	final int timer;

	AudioMixingState copyWith({
		EffectType selectedEffectType,
		AudioMixingStatus status,
		String audioLink,
		int timer,
	}) {
		return AudioMixingState(
			selectedEffectType: selectedEffectType ?? this.selectedEffectType,
			status: status ?? this.status,
			audioLink: audioLink ?? this.audioLink,
			timer: timer ?? this.timer,
		);
	}

  @override
  List<Object> get props => [selectedEffectType, status, audioLink, timer];
}