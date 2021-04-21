import 'package:audio_mixing_mobile_app/audio_mixing/dto/audio_mixing_dto.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/models/audio_mixing.dart';

extension AudioMixingMapper on AudioMixingDto {
	AudioMixing toModel() => AudioMixing(
		audioLink: audioLink,
	);
}