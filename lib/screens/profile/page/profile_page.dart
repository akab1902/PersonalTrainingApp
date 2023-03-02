import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/signin/page/signin_page.dart';

import '../../../core/const/color_constants.dart';
import '../bloc/profile_bloc.dart';
import '../widget/profile_content.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: ColorConstants.black,
                    ),
                  ),
                  const Text(
                    'Profile Page',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textBlack),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: const Icon(
                      Icons.edit,
                      color: ColorConstants.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildBody(context)
          ],
        )
    );
  }

  BlocProvider<ProfileBloc> _buildBody(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (BuildContext context) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
          buildWhen: (_, currState) => currState is ProfileInitial,
          builder: (context, state) {
            return const ProfileContent();
          },
          listenWhen: (_, currState) =>
          currState is ErrorState||
              currState is NextSignOutState,
          listener: (context, state) {
            if (state is NextSignOutState) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const SignInPage()));
            } else if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }),
    );
  }

}
