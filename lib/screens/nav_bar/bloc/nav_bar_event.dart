part of 'nav_bar_bloc.dart';

@immutable
abstract class NavBarEvent {}

class NavBarItemTappedEvent extends NavBarEvent {
  final int index;

  NavBarItemTappedEvent({required this.index});
}
