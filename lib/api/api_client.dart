import 'dart:io';

import 'package:audio_mixing_mobile_app/audio_mixing/dto/audio_mixing_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://demo-audio-mix.anyvoice.app/api/")
abstract class ApiClient {
	factory ApiClient(Dio dio) = _ApiClient;

	@POST("audio/mix")
	Future<AudioMixingDto> audioMixing(@Part() File audio);
}