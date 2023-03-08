import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/camera/bloc/camera_bloc.dart';
import 'package:personal_training_app/screens/camera/bloc/camera_utils.dart';
import 'package:personal_training_app/screens/camera/widget/record_button_widget.dart';

import '../../../core/const/color_constants.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Duration duration = Duration();
  Timer? timer;
  String val = 'Squats';
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<CameraBloc> _buildBody(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) => CameraBloc(cameraUtils: CameraUtils()),
      child: BlocConsumer<CameraBloc, CameraState>(
        buildWhen: (_, currState) => currState is CameraInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<CameraBloc>(context);
          if (state is CameraInitial) {
            bloc.add(CameraInitialized());
          }
          return cameraContent();
        },
        listenWhen: (_, currState) => currState is ErrorState,
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }

  Widget cameraContent() {
    return Container(
      width: double.infinity,
      color: ColorConstants.backgroundWhite,
      child: Stack(
        children: [
          BlocBuilder<CameraBloc, CameraState>(
            buildWhen: (_, currState) => currState is CameraReadyState,
            builder: (context, state) {
              return state is CameraReadyState &&
                      BlocProvider.of<CameraBloc>(context).getController() !=
                          null
                  ? SizedBox(
                      height: double.infinity,
                      child: CameraPreview(BlocProvider.of<CameraBloc>(context)
                          .getController()!))
                  : Container();
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _createDropDownMenu(),
                  _createButton(),
                  _createTimer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDropDownMenu() {
    final items = ['Squats', 'Push-ups', 'Pull-ups'];
    return BlocBuilder<CameraBloc, CameraState>(
      buildWhen: (_, currState) => currState is CameraReadyState,
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ))
                .toList(),
            value: val,
            dropdownStyleData: DropdownStyleData(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: ColorConstants.primaryColor,
              ),
            ),
            buttonStyleData: const ButtonStyleData(width: 130),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_up, color: ColorConstants.white),
            ),
            onChanged: (value) {
              setState(() {
                val = value!;
              });
            },
          ),
        );
      },
    );
  }

  Widget _createButton() {
    return BlocBuilder<CameraBloc, CameraState>(
      buildWhen: (_, currState) =>
          currState is CameraReadyState ||
          currState is CameraRecordingInProgressState ||
          currState is CameraRecordingSuccessState ||
          currState is CameraRecordingErrorState,
      builder: (context, state) {
        final bloc = BlocProvider.of<CameraBloc>(context);
        return BlocProvider.of<CameraBloc>(context).getController() != null
            ? RecordButton(
            isRecording: isRecording,
            onStart: () {
              isRecording = true;
                startTimer();
                // bloc.add(CameraStartRecording());
              }, onStop: () {
          isRecording = false;
          stopTimer();
                // bloc.add(CameraStopRecording());
              })
            : Container();
      },
    );
  }

  Widget _createTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      "$minutes:$seconds",
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: ColorConstants.textWhite),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    setState(() {
      duration = const Duration();
      timer?.cancel();
    });
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }
}
