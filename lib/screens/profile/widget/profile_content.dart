import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/%20common_widgets/custom_button.dart';
import 'package:personal_training_app/core/%20common_widgets/custom_tag_widget.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/screens/profile/bloc/profile_bloc.dart';
import '../../../core/const/path_constants.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (_, currState) => currState is InitialLoaded,
        builder: (context, state) {
          final bloc = BlocProvider.of<ProfileBloc>(context);
          return Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                            radius: 60,
                            backgroundImage: bloc.photoUrl != ""
                                ? NetworkImage(bloc.photoUrl)
                                : const AssetImage(
                                        PathConstants.profilePlaceholder)
                                    as ImageProvider),
                        onTap: () async {},
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        bloc.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                            color: ColorConstants.textBlack),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email: ${bloc.email}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Date of birth: ${bloc.dateOfBirth}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Gender: ${bloc.gender}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Height: ${bloc.height} cm",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Weight: ${bloc.weight} kg",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "BMI: ${bloc.bmi} ",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Goals:",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: ColorConstants.textBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _createGoalsList(bloc.goals)
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                        title: 'Sign Out',
                        onTap: () {
                          bloc.add(OnSignOutTapped());
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _createGoalsList(List<String> goals) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: goals.map((e) => CustomTag(content: e)).toList());
  }
}
