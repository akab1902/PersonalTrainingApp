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
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, currState) => currState is ReloadCalendarState,
              builder: (context, state) {
                final int today = state is ReloadCalendarState ? state.today ?? 1 : 1;
                final List<int> days =
                    state is ReloadCalendarState ? state.days ?? [] : [];
                return ListView.builder(
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    itemCount: days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return index == today - 1
                          ? Container(
                              decoration: BoxDecoration(
                                color: ColorConstants.primaryColorLight,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  days.elementAt(index).toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.textBlack),
                                ),
                              ),
                            )
                          : Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Text(
                                  days.elementAt(index).toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstants.textBlack),
                                ),
                            ),
                          );
                    });
              }),
        ),
      ],
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
        SizedBox(height: 150, child: _createTodaySessionList(context))
      ]),
    );
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

  Widget _createTodaySessionList(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, currState) => currState is ReloadTodaySessionState,
        builder: (context, state) {
          final List<Exercise> todaySessions =
              state is ReloadTodaySessionState ? state.todaySessions ?? [] : [];
          return ListView.builder(
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
                        bloc.add(OnExerciseTappedEvent(exercise: todaySessions[index]));
                      },
                      day: 2,
                      exercise: todaySessions[index]),
                );
              });
        });
  }

  Widget _createSuggestedProgramsList(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, currState) => currState is ReloadSuggestedProgramsState,
      builder: (context, state) {
        final List<Program> suggestedPrograms =
            state is ReloadSuggestedProgramsState
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
                  bloc.add(OnProgramTappedEvent(
                      programName: suggestedPrograms[index].name!));
                });
          },
        );
      },
    );
  }
}
