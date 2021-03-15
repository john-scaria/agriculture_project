part of 'qrfire_bloc.dart';

@immutable
abstract class QrfireState {}

class QrfireInitial extends QrfireState {
  final String message;
  QrfireInitial({@required this.message});
}

class QrSuccess extends QrfireState {
  final String qCode;
  QrSuccess({@required this.qCode});
}
