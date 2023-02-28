import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/camera/bloc/camera_bloc.dart';
import 'package:personal_training_app/screens/camera/bloc/camera_utils.dart';
import 'package:personal_training_app/screens/camera/widget/record_button.dart';

import '../../../core/const/color_constants.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(context)
    );
  }

  BlocProvider<CameraBloc> _buildBody(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) => CameraBloc(cameraUtils: CameraUtils()),
      child: BlocConsumer<CameraBloc,CameraState>(
        buildWhen: (_, currState) => currState is CameraInitial || currState is CameraInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<CameraBloc>(context);
          if(state is CameraInitial){
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

  Widget cameraContent(){
    return Container(
      width: double.infinity,
      color: ColorConstants.backgroundWhite,
      child: Stack(
        children: [
          BlocBuilder<CameraBloc, CameraState>(
            buildWhen: (_, currState) => currState is CameraReadyState,
            builder: (context, state) {
               return state is CameraReadyState && BlocProvider.of<CameraBloc>(context).getController() != null
                  ? CameraPreview(BlocProvider.of<CameraBloc>(context).getController()!)
                  : Container();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<CameraBloc, CameraState>(
                buildWhen: (_, currState) => currState is CameraReadyState || currState is CameraRecordingInProgressState || currState is CameraRecordingSuccessState || currState is CameraRecordingErrorState,
                builder: (context, state) {
                  return state is CameraReadyState && BlocProvider.of<CameraBloc>(context).getController() != null
                      ? RecordButton(onTap: (){})
                      : Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
