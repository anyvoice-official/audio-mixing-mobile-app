import 'package:json_annotation/json_annotation.dart';

part 'audio_mixing_dto.g.dart';

@JsonSerializable()
class AudioMixingDto {
	final String audioLink;

  AudioMixingDto({this.audioLink});

	factory AudioMixingDto.fromJson(Map<String, dynamic> json) => _$AudioMixingDtoFromJson(json);
}