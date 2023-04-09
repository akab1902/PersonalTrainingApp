import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

import '../../../core/ common_widgets/custom_button.dart';
import '../../../core/ common_widgets/custom_text_field.dart';
import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/text_constants.dart';
import '../../../core/service/validation_service.dart';
import '../bloc/signin_bloc.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({Key? key}) : super(key: key);

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
            BlocBuilder<SignInBloc, SignInState>(
                buildWhen: (_, currState) =>
                    currState is LoadingState || currState is ErrorState,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return _createLoading();
                  } else if (state is ErrorState) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                })
          ],
        ),
      ),
    );
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _createTitle(),
          const SizedBox(height: 20),
          _createForm(context),
          const SizedBox(height: 20),
          _createSignInButton(context),
          const SizedBox(height: 20),
          _createDontHaveAnAccount(context)
        ],
      ),
    ));
  }

  Widget _createTitle() {
    return const Text(
      TextConstants.signIn,
      style: TextStyle(
          color: ColorConstants.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _createSignInButton(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (_, currState) =>
            currState is SignInButtonEnableChangedState,
        builder: (context, state) {
          return CustomButton(
            title: TextConstants.signIn,
            isEnabled: state is SignInButtonEnableChangedState
                ? state.isEnabled
                : false,
            onTap: () {
              FocusScope.of(context).unfocus();
              bloc.add(OnSignInTappedEvent());
            },
          );
        },
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (_, currState) => currState is ShowErrorState,
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              title: 'Email',
              placeholder: 'example@email.com',
              errorText: 'Invalid email',
              controller: bloc.emailController,
              isError: state is ShowErrorState
                  ? !ValidationService.email(bloc.emailController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Password',
              placeholder: 'Enter password',
              errorText: 'Incorrect password',
              controller: bloc.passwordController,
              isError: state is ShowErrorState
                  ? !ValidationService.password(bloc.passwordController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createDontHaveAnAccount(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return Text.rich(TextSpan(
        text: "Don't have an account?",
        style: const TextStyle(color: ColorConstants.textBlack, fontSize: 18),
        children: [
          TextSpan(
              text: " ${TextConstants.signUp}",
              style: const TextStyle(
                  color: ColorConstants.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  bloc.add(OnSignUpTappedEvent());
                })
        ]));
  }
}
