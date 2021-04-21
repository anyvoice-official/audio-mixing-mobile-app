import 'package:audio_mixing_mobile_app/audio_mixing/bloc/audio_mixing_bloc.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/bloc/audio_mixing_event.dart';
import 'package:audio_mixing_mobile_app/audio_mixing/bloc/audio_mixing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioMixingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioMixingViewState();
}

class _AudioMixingViewState extends State<AudioMixingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: Text(
          "Audio Mixing",
        ),
      ),
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: BlocProvider(
						create: (context) => AudioMixingBloc(),
						child: BlocListener<AudioMixingBloc, AudioMixingState>(
							listener: (context, state) {
								if (state.status == AudioMixingStatus.submittedInProgress) {
									showDialog(
									 context: context,
										builder: (context) => AlertDialog(
      							  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      							  content: WillPopScope(
      							    onWillPop: () async => false, //disable back button
      							    child: Container(
      							      height: 60,
      							      child: CircularProgressIndicator(strokeWidth: 128.0),
      							    ),
      							  ),
      							),
									); 
								} 

								if (state.status == AudioMixingStatus.successSubmitted && state.status == AudioMixingStatus.errorSubmitted) {
									Navigator.of(context).pop();
								}
							},
							child: BlocBuilder<AudioMixingBloc, AudioMixingState>(
								builder: (context, state) {
									return Center(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												if (state.status == AudioMixingStatus.init) ...{
													RaisedButton(
														onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(StartRecordingAudioEvent()),
														child: Text(
															"Start recording"
														),
													)
												},

												if (state.status == AudioMixingStatus.recording) ...{
													Text(state.timer.toString()),
													SizedBox(height: 16.0),
													RaisedButton(
														onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(StopRecordingAudioEvent()),
														child: Text(
															"Stop recording"
														),
													),
												},

												if ((state.status == AudioMixingStatus.successRecording 
													|| state.status == AudioMixingStatus.playing) 
													&& !(state.status == AudioMixingStatus.successSubmitted)
												) ...{
													Text(state.timer.toString()),
													SizedBox(height: 16.0),
													Row(
														mainAxisAlignment: MainAxisAlignment.center,
														crossAxisAlignment: CrossAxisAlignment.center,
														children: [
															RaisedButton(
																onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(StartRecordingAudioEvent()),
																child: Text(
																	"Rerecording"
																),
															),
															SizedBox(width: 8.0),
															if (state.status == AudioMixingStatus.playing) ...{
																RaisedButton(
																	onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(
																		StopPlayingAudioEvent()),
																	child: Text(
																		"Stop playing"
																	),
																),
															} else ...{
																RaisedButton(
																	onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(
																		StartPlayingAudioFromLocalFileEvent()),
																	child: Text(
																		"Start playing"
																	),
																),
															},
														],
													),
													RaisedButton(
														onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(
															SubmittedEvent()),
														child: Text(
															"Added background"
														),
													),															
												},
												if (state.status == AudioMixingStatus.successSubmitted) ...{
													if (state.status == AudioMixingStatus.playing) ...{
														RaisedButton(
															onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(StopPlayingAudioEvent()),
															child: Text(
																"Stop playing"
															),
														),
													}	else ...{
														RaisedButton(
															onPressed: () => BlocProvider.of<AudioMixingBloc>(context).add(
																StartPlayingAudioFromNetworkEvent(state.audioLink)),
															child: Text(
																"Playing result"
															),
														),
													}
												}
											],
										)
									);
								}
							),
						),
					)
				),
			),
    );
  }
}