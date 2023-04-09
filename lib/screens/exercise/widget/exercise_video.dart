import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';
import '../../../data/models/exercise_model.dart';

class ExerciseVideo extends StatefulWidget {
  final Exercise exercise;
  final Function(int) onPlayTapped;
  final Function(int) onPauseTapped;

  ExerciseVideo(
      {required this.exercise,
      required this.onPlayTapped,
      required this.onPauseTapped,
      Key? key})
      : super(key: key);

  @override
  _ExerciseVideoState createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  late VideoPlayerController _controller;

  late bool isPlayButtonHidden = false;
  late ChewieController _chewieController;
  Timer? timer;
  Timer? videoTimer;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.exercise.videoUrl);

    _controller.initialize();

    _chewieController = ChewieController(
        videoPlayerController: _controller,
        looping: true,
        autoPlay: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 15 / 10,
        placeholder: const Center(child: CupertinoActivityIndicator()),
        materialProgressColors:
            ChewieProgressColors(playedColor: ColorConstants.primaryColor));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: _createVideoContainer());
  }

  Widget _createVideoContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Theme(
            data: Theme.of(context).copyWith(platform: TargetPlatform.android),
            child: Chewie(controller: _chewieController)),
      ),
    );
  }
}
