import 'package:agriculture_project/repositories/rive_client.dart';
import 'package:meta/meta.dart';
import 'package:rive/rive.dart';

class RiveRepository {
  final RiveClient riveClient;
  RiveRepository({@required this.riveClient});

  Artboard addArtboard(String title) => riveClient.addArtboard(title);
}
