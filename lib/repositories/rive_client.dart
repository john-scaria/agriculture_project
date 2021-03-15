import 'package:rive/rive.dart';
import 'package:meta/meta.dart';

class RiveClient {
  final Artboard artboard;
  RiveClient({@required this.artboard});

  Artboard addArtboard(String animTitle) {
    return artboard
      ..addController(
        SimpleAnimation(animTitle),
      );
  }
}
