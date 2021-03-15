part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class NavigationTabTap extends NavigationEvent {
  final int index;
  NavigationTabTap({@required this.index});
}
