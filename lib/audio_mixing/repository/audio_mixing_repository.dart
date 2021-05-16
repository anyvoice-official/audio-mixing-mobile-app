import 'dart:io';

import 'package:audio_mixing_mobile_app/api/api_client.dart';
import 'package:audio_mixing_mobile_app/api/dio.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/models/audio_mixing.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/mappers/audio_mixing_mapper.dart';

class AudioMixingRepository {
	final ApiClient _api = ApiClient(dio);

	Future<AudioMixing> audioMixing(File file) async {
		final response = await _api.audioMixing(file);
		
		return response.toModel();
	}
}