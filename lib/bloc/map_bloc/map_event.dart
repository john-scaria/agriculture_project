part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class FullMapEvent extends MapEvent {
  final String animTitle;
  FullMapEvent({@required this.animTitle});
}

class SingleMapEvent extends MapEvent {
  final String animTitle;
  final String cropName;
  SingleMapEvent({@required this.animTitle, @required this.cropName});
}

class QrMapEvent extends MapEvent {
  final String qrCode;
  QrMapEvent({@required this.qrCode});
}
