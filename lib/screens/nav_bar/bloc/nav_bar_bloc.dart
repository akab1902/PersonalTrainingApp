import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nav_bar_event.dart';

part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial()) {
    on<NavBarItemTappedEvent>(_onItemTapped);
  }

  int currentIndex = 0;
  bool isSelected = false;

  void _onItemTapped(
      NavBarItemTappedEvent event, Emitter<NavBarState> emit) async {
    currentIndex = event.index;
    emit(NavBarItemSelectedState(index: currentIndex));
  }
}
