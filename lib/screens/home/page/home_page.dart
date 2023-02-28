import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/home/bloc/home_bloc.dart';
import 'package:personal_training_app/screens/program/page/program_page.dart';

import '../../profile/page/profile_page.dart';
import '../widget/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context)
    );
  }

  BlocProvider<HomeBloc> _buildBody(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: BlocConsumer<HomeBloc,HomeState>(
        buildWhen: (_, currState) => currState is HomeInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<HomeBloc>(context);
          if(state is HomeInitial){
            bloc.add(HomeInitialEvent());
            bloc.add(ReloadDisplayNameEvent());
            bloc.add(ReloadImageEvent());
            bloc.add(ReloadSuggestedProgramsEvent());
          }
          return const HomeContent();
        },
        listenWhen: (_, currState) => currState is ErrorState || currState is NextExercisePageState || currState is NextProgramPageState || currState is NextProfilePageState,
        listener: (context, state) {
          if(state is NextExercisePageState){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          } else if(state is NextProgramPageState){
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProgramPage(programName: state.programName)));
          } else if(state is NextProfilePageState){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
