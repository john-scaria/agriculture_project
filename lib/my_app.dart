import 'package:agriculture_project/bloc/map_bloc/map_bloc.dart';
import 'package:agriculture_project/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:agriculture_project/bloc/qrfire_bloc/qrfire_bloc.dart';
import 'package:agriculture_project/repositories/rive_client.dart';
import 'package:agriculture_project/repositories/rive_repository.dart';
import 'package:agriculture_project/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

class MyApp extends StatelessWidget {
  final RiveFile riveFile;
  const MyApp({
    @required this.riveFile,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<QrfireBloc>(
            create: (context) => QrfireBloc(),
          ),
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(
              riveRepository: RiveRepository(
                riveClient: RiveClient(
                  artboard: riveFile.mainArtboard,
                ),
              ),
            ),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
