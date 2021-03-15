part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {
  final Artboard artboard;
  MapInitial({@required this.artboard});
}

class FullMapLoad extends MapState {
  final Artboard artboard;
  FullMapLoad({@required this.artboard});
}

class SingleMapLoad extends MapState {
  final Artboard artboard;
  final String cropName;
  SingleMapLoad({
    @required this.artboard,
    @required this.cropName,
  });
}

class QrSuccessMapLoad extends MapState {
  final Artboard artboard;
  final String cropName;
  final String qCode;
  QrSuccessMapLoad({
    @required this.artboard,
    @required this.cropName,
    @required this.qCode,
  });
}

class QrFailMapLoad extends MapState {
  final String message;
  QrFailMapLoad({@required this.message});
}
