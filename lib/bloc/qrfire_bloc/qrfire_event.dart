part of 'qrfire_bloc.dart';

@immutable
abstract class QrfireEvent {}

class QrScanned extends QrfireEvent {
  final String qCode;
  QrScanned({@required this.qCode});
}

class QrInitFire extends QrfireEvent {}
