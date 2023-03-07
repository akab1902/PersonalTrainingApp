import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/const/path_constants.dart';
import '../../profile/page/profile_page.dart';
import '../bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(context)
    );
  }

  BlocProvider<StatsBloc> _buildBody(BuildContext context) {
    return BlocProvider<StatsBloc>(
      create: (context) => StatsBloc(),
      child: BlocConsumer<StatsBloc,StatsState>(
        buildWhen: (_, currState) => currState is StatsInitial || currState is LoadingState,
        builder: (context, state) {
          final bloc = BlocProvider.of<StatsBloc>(context);
          if(state is StatsInitial){
            bloc.add(StatsInitialEvent());
            bloc.add(ReloadImageEvent());
          }
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 55),
                  _createTitle(context),
                  _createTimeGraph(),
                  _createExerciseCounts()
                ],
              ),
              if (state is LoadingState)
                _createLoading()
          ],
          );
        },
        listenWhen: (_, currState) => currState is ErrorState || currState is NextProfilePageState,
        listener: (context, state) {
          if(state is NextProfilePageState){
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

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createTitle(BuildContext context){
    final bloc = BlocProvider.of<StatsBloc>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          const Text(
          'My Trainings',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textBlack),
            ),
            BlocBuilder<StatsBloc, StatsState>(
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

  Widget _createExerciseCounts(){
    return Container();
  }

  Widget _createTimeGraph(){
    return Container();
  }
}
