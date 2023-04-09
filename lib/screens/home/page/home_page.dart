import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/exercise/page/exercise_page.dart';
import 'package:personal_training_app/screens/home/bloc/home_bloc.dart';
import 'package:personal_training_app/screens/program/page/program_page.dart';

import '../../profile/page/profile_page.dart';
import '../widget/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<HomeBloc> _buildBody(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        buildWhen: (_, currState) =>
            currState is HomeInitial || currState is InitialLoaded,
        builder: (context, state) {
          final bloc = BlocProvider.of<HomeBloc>(context);
          if (state is HomeInitial) {
            bloc.add(HomeInitialEvent());
          }
          if (state is InitialLoaded) {
            bloc.add(ReloadDisplayNameEvent());
            bloc.add(ReloadImageEvent());
            bloc.add(ReloadTodaySessionEvent());
            bloc.add(ReloadSuggestedProgramsEvent());
            bloc.add(ReloadOtherProgramsEvent());
          }
          return const HomeContent();
        },
        listenWhen: (_, currState) =>
            currState is ErrorState ||
            currState is NextExercisePageState ||
            currState is NextProgramPageState ||
            currState is NextProfilePageState,
        listener: (context, state) {
          final bloc = BlocProvider.of<HomeBloc>(context);
          if (state is NextExercisePageState) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ExercisePage(exercise: state.exercise)))
                .then((value) {
              bloc.add(HomeInitialEvent());
            });
          } else if (state is NextProgramPageState) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProgramPage(program: state.program)))
                .then((value) {
              bloc.add(HomeInitialEvent());
            });
          } else if (state is NextProfilePageState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }
}
