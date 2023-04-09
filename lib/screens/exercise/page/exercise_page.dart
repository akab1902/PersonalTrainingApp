import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/exercise/bloc/exercise_bloc.dart';
import 'package:personal_training_app/screens/exercise/widget/exercise_content.dart';

import '../../../core/const/color_constants.dart';
import '../../../data/models/exercise_model.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  final bool viewOnly;

  const ExercisePage({required this.exercise, this.viewOnly = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<ExerciseBloc> _buildBody(BuildContext context) {
    return BlocProvider<ExerciseBloc>(
      create: (context) => ExerciseBloc(),
      child: BlocConsumer<ExerciseBloc, ExerciseState>(
        buildWhen: (_, currState) => currState is ExerciseInitial,
        builder: (context, state) {
          return ExerciseContent(exercise: exercise, viewOnly: viewOnly);
        },
        listenWhen: (_, currState) =>
            currState is BackTappedState || currState is FinishSuccessState,
        listener: (context, state) {
          if (state is BackTappedState) {
            Navigator.pop(context);
          }
          if (state is FinishSuccessState) {
            if (state.success) {
              showDialogWithSuccess(context);
              Timer(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            } else {
              showDialogWithError(context, "Could not add program");
              Timer(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            }
          }
        },
      ),
    );
  }

  showDialogWithError(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: ColorConstants.transparent,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error_outline_rounded,
                          color: ColorConstants.errorColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ERROR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  showDialogWithSuccess(BuildContext context) {
    showDialog(
        barrierColor: ColorConstants.transparent,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check_circle_rounded,
                          color: ColorConstants.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Finished exercise",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
  }
}
