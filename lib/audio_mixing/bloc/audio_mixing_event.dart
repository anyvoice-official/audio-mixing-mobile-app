import 'package:equatable/equatable.dart';

abstract class AudioMixingEvent extends Equatable {
	const AudioMixingEvent();

	@override
	List<Object> get props => [];
}

class StartRecordingAudioEvent extends AudioMixingEvent {}

class UpdateTimerEvent extends AudioMixingEvent {
	const UpdateTimerEvent(this.timer);

	final int timer;

	@override
	List<Object> get props => [timer];
}

class StopRecordingAudioEvent extends AudioMixingEvent {}

class StartPlayingAudioFromLocalFileEvent extends AudioMixingEvent {}

class StartPlayingAudioFromNetworkEvent extends AudioMixingEvent {
	const StartPlayingAudioFromNetworkEvent(this.audioLink);

	final String audioLink;

	@override
	List<Object> get props => [audioLink];
}

class StopPlayingAudioEvent extends AudioMixingEvent {}

class SubmittedEvent extends AudioMixingEvent {}