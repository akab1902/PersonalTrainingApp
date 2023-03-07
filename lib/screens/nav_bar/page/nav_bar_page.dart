import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/core/const/path_constants.dart';
import 'package:personal_training_app/screens/camera/page/camera_page.dart';
import 'package:personal_training_app/screens/home/page/home_page.dart';
import 'package:personal_training_app/screens/stats/page/stats_page.dart';

import '../bloc/nav_bar_bloc.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavBarBloc>(
        create: (context) => NavBarBloc(),
        child: BlocConsumer<NavBarBloc, NavBarState>(
          listener: (context, state) {},
          buildWhen: (_, currState) =>
              currState is NavBarInitial ||
              currState is NavBarItemSelectedState,
          builder: (context, state) {
            final bloc = BlocProvider.of<NavBarBloc>(context);
            return Scaffold(
              body: _createBody(context, bloc.currentIndex),
              bottomNavigationBar: _createBottomNavBar(context),
            );
          },
        ));
  }

  Widget _createBottomNavBar(BuildContext context) {
    final bloc = BlocProvider.of<NavBarBloc>(context);
    return BottomNavigationBar(
      currentIndex: bloc.currentIndex,
      fixedColor: ColorConstants.primaryColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PathConstants.sportIcon,
              colorFilter: ColorFilter.mode(
                  bloc.currentIndex == 0
                      ? ColorConstants.primaryColor
                      : ColorConstants.grey,
                  BlendMode.srcIn),
            ),
            label: 'home'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PathConstants.cameraIcon,
              colorFilter: ColorFilter.mode(
                  bloc.currentIndex == 1
                      ? ColorConstants.primaryColor
                      : ColorConstants.grey,
                  BlendMode.srcIn),
            ),
            label: 'camera'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PathConstants.statsIcon,
              colorFilter: ColorFilter.mode(
                  bloc.currentIndex == 2
                      ? ColorConstants.primaryColor
                      : ColorConstants.grey,
                  BlendMode.srcIn),
            ),
            label: 'stats')
      ],
      onTap: (index) {
        bloc.add(NavBarItemTappedEvent(index: index));
      },
    );
  }

  Widget _createBody(BuildContext context, int index) {
    final pages = [const HomePage(), const CameraPage(), const StatsPage()];
    return pages[index];
  }
}
