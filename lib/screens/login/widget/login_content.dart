import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

import '../../../core/ common_widgets/loading_widget.dart';
import '../bloc/login_bloc.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({Key? key}) : super(key: key);

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
            // _createMainData(context),
            BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (_, currState) => currState is LoadingState || currState is ErrorState,
                builder: (context, state) {
                  if(state is LoadingState) {
                    return _createLoading();
                  } else if(state is ErrorState) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }
}

