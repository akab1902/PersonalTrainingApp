import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/page/home.dart';
import '../bloc/login_bloc.dart';
import '../widget/login_content.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<LoginBloc> _buildBody(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState> (
        buildWhen: (_, currState) => currState is LoginInitial,
        builder: (context, state) {
          return const LoginContent();
        },
        listenWhen: (_, currState) =>
          currState is ErrorState || currState is NextHomePageState,
        listener: (context, state) {
          if (state is NextHomePageState) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
            );
          }
        }),
      );
  }

}
