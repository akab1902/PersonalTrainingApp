import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/%20common_widgets/custom_button.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/screens/profile/bloc/profile_bloc.dart';

import '../../../core/const/path_constants.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProfileBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (_, currState) => currState is ProfileInitial,
            builder: (context, state) {
              // final photoUrl =
              // state is ProfileInitial ? state.photoURL : null;
              return GestureDetector(
                child: const CircleAvatar(
                  backgroundImage:
                  AssetImage(PathConstants.profilePlaceholder),
                  radius: 50,
                ),
                //     : CircleAvatar(
                //   radius: 30,
                //   child: ClipOval(
                //     child: FadeInImage.assetNetwork(
                //       placeholder: PathConstants.profilePlaceholder,
                //       image: photoUrl,
                //       fit: BoxFit.cover,
                //       width: 200,
                //       height: 120,
                //     ),
                //   ),
                // ),
                onTap: () async {

                },
              );
            },
          ),
          const SizedBox(height: 30,),
          const Text(
            "UserName",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24,
                color: ColorConstants.textBlack),
          ),
          const SizedBox(height: 30,),
          CustomButton(
              title: 'Sign Out',
              onTap: () {
                bloc.add(OnSignOutTapped());
              }
          )
        ],
      ),
    );
  }
}
