import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/stats/widget/stats_content.dart';
import '../../profile/page/profile_page.dart';
import '../bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<StatsBloc> _buildBody(BuildContext context) {
    return BlocProvider<StatsBloc>(
      create: (context) => StatsBloc(),
      child: BlocConsumer<StatsBloc, StatsState>(
        buildWhen: (_, currState) =>
            currState is StatsInitial ||
            currState is LoadingState ||
            currState is InitialLoaded,
        builder: (context, state) {
          final bloc = BlocProvider.of<StatsBloc>(context);
          if (state is StatsInitial) {
            bloc.add(StatsInitialEvent());
          }
          if (state is InitialLoaded) {
            bloc.add(ReloadImageEvent());
            bloc.add(ReloadHistoryEvent());
          }
          return const StatsContent();
        },
        listenWhen: (_, currState) =>
            currState is ErrorState || currState is NextProfilePageState,
        listener: (context, state) {
          if (state is NextProfilePageState) {
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
