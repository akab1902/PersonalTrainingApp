import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/core/const/text_constants.dart';
import 'package:personal_training_app/screens/signup/bloc/signup_bloc.dart';

import '../../../core/ common_widgets/custom_button.dart';
import '../../../core/ common_widgets/custom_text_field.dart';
import '../../../core/ common_widgets/loading_widget.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.backgroundWhite,
        child: Stack(
          children: [
            _createMainData(context),
            BlocBuilder<SignupBloc, SignupState>(
                buildWhen: (_, currState) =>
                    currState is LoadingState ||
                    currState is NextHomePageState ||
                    currState is NextLoginPageState,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return _createLoading();
                  } else if (state is NextLoginPageState ||
                      state is ErrorState ||
                      state is NextHomePageState) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                })
          ],
        ),
      ),
    );
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _createTitle(),
          const SizedBox(
            height: 20,
          ),
          _createForm(context),
        ],
      ),
    ));
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createTitle() {
    return const Text(
      TextConstants.signUp,
      style: TextStyle(
          color: ColorConstants.texBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _createSignUpButton(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (_, currState) => currState is SignUpButtonEnableChangedState,
        builder: (context, state) {
          return CustomButton();
        },
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    // final bloc = BlocProvider.of<SignupBloc>(context);
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (_, currState) => currState is ShowErrorState,
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              title: 'Username',
              placeholder: 'username',
              errorText: 'No text',
              controller: TextEditingController(),
              onTextChanged: () {},
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
