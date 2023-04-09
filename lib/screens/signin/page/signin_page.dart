import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/nav_bar/page/nav_bar_page.dart';
import 'package:personal_training_app/screens/signup/page/signup_page.dart';

import '../bloc/signin_bloc.dart';
import '../widget/signin_content.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<SignInBloc> _buildBody(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (BuildContext context) => SignInBloc(),
      child: BlocConsumer<SignInBloc, SignInState>(
          buildWhen: (_, currState) => currState is SignInInitial,
          builder: (context, state) {
            return const SignInContent();
          },
          listenWhen: (_, currState) =>
              currState is ErrorState ||
              currState is NextHomePageState ||
              currState is NextSignUpPageState,
          listener: (context, state) {
            if (state is NextHomePageState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const NavBarPage()));
            } else if (state is NextSignUpPageState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SignupPage()));
            } else if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }),
    );
  }
}
