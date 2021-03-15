import 'package:agriculture_project/bloc/map_bloc/map_bloc.dart';
import 'package:agriculture_project/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:agriculture_project/screens/all_plant_page.dart';
import 'package:agriculture_project/screens/map_body.dart';
import 'package:agriculture_project/screens/plant_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _bottomNavChildren = [
    MapBody(),
    PlantBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plantation App'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: Center(
                  child: Text(
                    'Extras',
                  ),
                ),
              ),
              ListTile(
                title: const Text('All Plants'),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllPlantPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is NavigationInitial) {
              return _bottomNavChildren[state.index];
            }
            if (state is NavigationTabState) {
              return _bottomNavChildren[state.index];
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is NavigationInitial) {
              return _bottomNavigationBar(state.index);
            }
            if (state is NavigationTabState) {
              return _bottomNavigationBar(state.index);
            }
            return _bottomNavigationBar(0);
          },
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar(int index) => BottomNavigationBar(
        currentIndex: index,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            label: 'Crop',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.agriculture,
            ),
            label: 'Plants',
          ),
        ],
      );

  void _onTabTapped(int index) {
    BlocProvider.of<NavigationBloc>(context).add(
      NavigationTabTap(index: index),
    );
    if (index == 0) {
      BlocProvider.of<MapBloc>(context).add(
        FullMapEvent(animTitle: 'idle'),
      );
    }
    /* if (index == 1) {
      BlocProvider.of<QrfireBloc>(context).add(
        QrInitFire(),
      );
    } */
  }
}
