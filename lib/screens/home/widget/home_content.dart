import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/data/program_model.dart';
import 'package:personal_training_app/screens/home/bloc/home_bloc.dart';
import 'package:personal_training_app/screens/home/widget/program_item.dart';
import 'package:personal_training_app/screens/profile/page/profile_page.dart';
import 'package:personal_training_app/screens/signin/page/signin_page.dart';

import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/const/path_constants.dart';
import '../../../core/service/logger.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

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
            BlocBuilder<HomeBloc, HomeState>(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _createProfileHeader(context),
            const SizedBox(height: 40),
            _createCalendar(context),
            const SizedBox(height: 30),
            _createTodaySession(context),
            const SizedBox(height: 30),
            _createSuggestedPrograms(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _createProfileHeader(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, currState) => currState is ReloadDisplayNameState,
              builder: (context, state) {
                final displayName = state is ReloadDisplayNameState
                    ? state.displayName
                    : '[name]';
                return Text(
                  'Hi, $displayName',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textBlack),
                );
              },
            ),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, currState) => currState is ReloadImageState,
              builder: (context, state) {
                final photoUrl =
                    state is ReloadImageState ? state.photoURL : null;
                return GestureDetector(
                  child: photoUrl == null
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage(PathConstants.profilePlaceholder),
                          radius: 30,
                        )
                      : CircleAvatar(
                          radius: 30,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: PathConstants.profilePlaceholder,
                              image: photoUrl,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 120,
                            ),
                          ),
                        ),
                  onTap: () async {
                    bloc.add(OnProfileTappedEvent());
                    bloc.add(ReloadImageEvent());
                  },
                );
              },
            ),
          ],
        ));
  }

  Widget _createTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 24,
          color: ColorConstants.textBlack),
    );
  }

  Widget _createCalendar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        '1    2    3    4    5    6    8    9    10',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24,
            color: ColorConstants.textBlack),
      ),
    );
  }

  Widget _createTodaySession(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: _createTitle('Today\'s session'),
        ));
  }

  Widget _createSuggestedPrograms(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createTitle('Suggested Programs'),
            const SizedBox(height: 20),
            _createSuggestedProgramsList(context),
          ],
        ));
  }

  Widget _createSuggestedProgramsList(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, currState) => currState is ReloadSuggestedProgramsState,
      builder: (context, state) {
        final List<Program> suggestedPrograms = state is ReloadSuggestedProgramsState
            ? state.suggestedPrograms ?? []
            : [];
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: suggestedPrograms.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
          itemBuilder: (BuildContext context, int index) {
            return ProgramItem(
                program: suggestedPrograms[index],
                onTap: () {
                  bloc.add(OnProgramTappedEvent(programName: suggestedPrograms[index].name!));
                });
          },
        );
      },
    );
  }
}
