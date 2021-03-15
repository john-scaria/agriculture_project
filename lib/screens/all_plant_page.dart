import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllPlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Plants'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: PlantInformation(),
        ),
      ),
    );
  }
}

class PlantInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference plants =
        FirebaseFirestore.instance.collection('plants');

    return StreamBuilder<QuerySnapshot>(
      stream: plants.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong',
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text('${document.data()['name']}'),
            );
          }).toList(),
        );
      },
    );
  }
}
