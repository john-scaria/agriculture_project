part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {
  final int index;
  NavigationInitial({@required this.index});
}

class NavigationTabState extends NavigationState {
  final int index;
  NavigationTabState({@required this.index});
}
