import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/data/models/program_model.dart';
import 'package:personal_training_app/screens/home/bloc/home_bloc.dart';
import 'package:personal_training_app/screens/home/widget/program_item.dart';
import 'package:personal_training_app/screens/home/widget/today_session_item.dart';
import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/const/path_constants.dart';
import '../../../data/models/exercise_model.dart';

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
                    currState is LoadingState ||
                    currState is ErrorState ||
                    currState is InitialLoaded,
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
            const SizedBox(height: 30),
            _createTodaySession(context),
            const SizedBox(height: 30),
            _createSuggestedPrograms(context),
            _createOtherPrograms(context),
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
                  'Hi, $displayName !',
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
                  child: photoUrl == null || photoUrl == ""
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

  Widget _createTodaySession(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _createTitle('Today\'s session'),
        const SizedBox(
          height: 20,
        ),
        _createTodaySessionList(context)
      ]),
    );
  }

  Widget _createSuggestedPrograms(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, currState) => currState is ReloadSuggestedProgramsState,
        builder: (context, state) {
          final List<Program> suggestedPrograms =
              state is ReloadSuggestedProgramsState
                  ? state.suggestedPrograms ?? []
                  : [];
          return suggestedPrograms.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _createTitle('Suggested Programs'),
                      const SizedBox(height: 20),
                      _createSuggestedProgramsList(context, suggestedPrograms),
                      const SizedBox(height: 30),
                    ],
                  ))
              : Container();
        });
  }

  Widget _createOtherPrograms(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, currState) => currState is ReloadOtherProgramsState,
        builder: (context, state) {
          final List<Program> otherPrograms = state is ReloadOtherProgramsState
              ? state.otherPrograms ?? []
              : [];
          return otherPrograms.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _createTitle('Other Programs'),
                      const SizedBox(height: 20),
                      _createOtherProgramsList(context, otherPrograms),
                      const SizedBox(height: 30),
                    ],
                  ))
              : Container();
        });
  }

  Widget _createTodaySessionList(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, currState) => currState is ReloadTodaySessionState,
        builder: (context, state) {
          final List<Exercise> todaySessions =
              state is ReloadTodaySessionState ? state.todaySessions ?? [] : [];
          return SizedBox(
              height: todaySessions.isNotEmpty ? 150 : 90,
              child: todaySessions.isNotEmpty
                  ? ListView.builder(
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemCount: todaySessions.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: width * 0.9,
                          padding: const EdgeInsets.only(right: 20),
                          child: ExerciseItem(
                              onTap: () {
                                bloc.add(OnExerciseTappedEvent(
                                    exercise: todaySessions[index]));
                              },
                              exercise: todaySessions[index]),
                        );
                      })
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Center(
                            child: Icon(
                          Icons.check_circle_rounded,
                          size: 50,
                          color: ColorConstants.green,
                        )),
                        Text(
                          "You are done for today!",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: ColorConstants.primaryColor),
                        ),
                        Text(
                          "No more exercises",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: ColorConstants.primaryColor),
                        ),
                      ],
                    ));
        });
  }

  Widget _createOtherProgramsList(
      BuildContext context, List<Program> otherPrograms) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: otherPrograms.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemBuilder: (BuildContext context, int index) {
        return ProgramItem(
            program: otherPrograms[index],
            onTap: () {
              bloc.add(OnProgramTappedEvent(program: otherPrograms[index]));
            });
      },
    );
  }

  Widget _createSuggestedProgramsList(
      BuildContext context, List<Program> suggestedPrograms) {
    final bloc = BlocProvider.of<HomeBloc>(context);
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
              bloc.add(OnProgramTappedEvent(program: suggestedPrograms[index]));
            });
      },
    );
  }
}
