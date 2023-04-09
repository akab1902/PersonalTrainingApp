import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../signin/page/signin_page.dart';
import '../bloc/signup_bloc.dart';
import '../widget/signup_content.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<SignupBloc> _buildBody(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (BuildContext context) => SignupBloc(),
      child: BlocConsumer<SignupBloc, SignupState>(
        listenWhen: (_, currState) =>
            currState is NextLoginPageState || currState is ErrorState,
        listener: (context, state) {
          if (state is NextLoginPageState) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInPage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (_, currState) => currState is SignupInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<SignupBloc>(context);
          if (state is SignupInitial) {
            bloc.add(SignUpInitialEvent());
          }
          return const SignUpContent();
        },
      ),
    );
  }
}
