part of 'nav_bar_bloc.dart';

@immutable
abstract class NavBarState {}

class NavBarInitial extends NavBarState {}

class NavBarItemSelectedState extends NavBarState {
  final int index;

  NavBarItemSelectedState({required this.index});
}
