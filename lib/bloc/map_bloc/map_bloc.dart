import 'dart:async';

import 'package:agriculture_project/repositories/rive_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rive/rive.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({@required this.riveRepository})
      : super(
          MapInitial(
            artboard: riveRepository.addArtboard('idle'),
          ),
        );

  final RiveRepository riveRepository;

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is FullMapEvent) {
      yield FullMapLoad(
        artboard: riveRepository.addArtboard(event.animTitle),
      );
    }
    if (event is SingleMapEvent) {
      yield SingleMapLoad(
        artboard: riveRepository.addArtboard(event.animTitle),
        cropName: event.cropName,
      );
    }
    if (event is QrMapEvent) {
      switch (event.qrCode) {
        case 'fullcrop':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('idle'),
            cropName: 'Full Crop',
            qCode: event.qrCode,
          );
          break;
        case 'crop1':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop1_anim'),
            cropName: 'Crop 1',
            qCode: event.qrCode,
          );
          break;
        case 'crop2':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop2_anim'),
            cropName: 'Crop 2',
            qCode: event.qrCode,
          );
          break;
        case 'crop3':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop3_anim'),
            cropName: 'Crop 3',
            qCode: event.qrCode,
          );
          break;
        case 'crop4':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop4_anim'),
            cropName: 'Crop 4',
            qCode: event.qrCode,
          );
          break;
        case 'crop5':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop5_anim'),
            cropName: 'Crop 5',
            qCode: event.qrCode,
          );
          break;
        case 'crop6':
          yield QrSuccessMapLoad(
            artboard: riveRepository.addArtboard('crop6_anim'),
            cropName: 'Crop 6',
            qCode: event.qrCode,
          );
          break;
        case '-1':
          yield FullMapLoad(
            artboard: riveRepository.addArtboard('idle'),
          );
          break;
        default:
          yield QrFailMapLoad(message: 'No Crop Available!!');
          break;
      }
    }
  }
}
