import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/%20common_widgets/custom_button.dart';
import 'package:personal_training_app/screens/exercise/page/exercise_page.dart';
import '../../../core/const/color_constants.dart';
import '../../../data/models/program_model.dart';
import '../bloc/program_bloc.dart';
import '../widget/program_content.dart';

class ProgramPage extends StatelessWidget {
  final Program program;

  const ProgramPage({required this.program, Key? key}) : super(key: key);

  @override
  BlocProvider<ProgramBloc> build(BuildContext context) {
    return BlocProvider<ProgramBloc>(
      create: (context) => ProgramBloc(),
      child: BlocConsumer<ProgramBloc, ProgramState>(
        buildWhen: (_, currState) => currState is ProgramInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<ProgramBloc>(context);
          bloc.add(ProgramInitialEvent(program: program));
          return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<ProgramBloc, ProgramState>(
                  buildWhen: (_, currState) =>
                      currState is AddButtonChangedState,
                  builder: (context, state) {
                    return CustomButton(
                      title: "Add",
                      isEnabled: state is AddButtonChangedState
                          ? state.enabled
                          : false,
                      onTap: () {
                        bloc.add(AddTappedEvent());
                      },
                    );
                  },
                ),
              ),
              body: ProgramContent(program: program));
        },
        listenWhen: (_, currState) =>
            currState is ExerciseTappedState || currState is AddSuccessState,
        listener: (context, state) async {
          if (state is ExerciseTappedState) {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) =>
                    ExercisePage(exercise: state.exercise, viewOnly: true),
              ),
            );
            final bloc = BlocProvider.of<ProgramBloc>(context);
            bloc.add(ProgramInitialEvent(program: program));
          }
          if (state is AddSuccessState) {
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
                          "Added program",
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
