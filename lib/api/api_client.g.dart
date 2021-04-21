// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://demo-audio-mix.anyvoice.app/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<AudioMixingDto> audioMixing(audio) async {
    ArgumentError.checkNotNull(audio, 'audio');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'audio',
        MultipartFile.fromFileSync(audio.path,
            filename: audio.path.split(Platform.pathSeparator).last)));
    final _result = await _dio.request<Map<String, dynamic>>('audio/mix',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AudioMixingDto.fromJson(_result.data);
    return value;
  }
}
