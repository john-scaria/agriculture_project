import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CropWithDetails extends StatelessWidget {
  final String value;
  final Size size;
  final Artboard artboard;
  const CropWithDetails({
    @required this.value,
    @required this.size,
    @required this.artboard,
  });
  @override
  Widget build(BuildContext context) {
    if (value.isEmpty || value == null) {
      return const Center(
        child: Text(
          'Scan to Get Details!!',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    try {
      final CollectionReference crops =
          FirebaseFirestore.instance.collection('crops');

      return FutureBuilder<DocumentSnapshot>(
        future: crops.doc(value).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Data not Available!!"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            try {
              final Map<String, dynamic> data = snapshot.data.data();
              final CropRecord cropRecord = CropRecord.fromMap(data);
              final List<dynamic> _plantList = cropRecord.plants;
              if (data == null || data.isEmpty) {
                return const Center(child: Text('Data not Available!!'));
              }
              return _cropResultDisplay(
                _plantList,
                cropRecord.name,
                cropRecord.area,
                size,
                artboard,
              );
            } catch (_) {
              return const Center(
                child: Text('Data not Available'),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    } on PlatformException {
      return const Center(child: Text("Error Occured"));
    } catch (_) {
      return const Center(child: Text("Error Occured"));
    }
  }
}

Column _cropResultDisplay(
  List<dynamic> _plantList,
  String _cropName,
  String _area,
  Size _size,
  Artboard _artboard,
) =>
    Column(
      children: [
        SizedBox(
          height: _size.height / 2,
          width: _size.width,
          child: _artboard != null
              ? Rive(
                  artboard: _artboard,
                )
              : const SizedBox(),
        ),
        Text(
          'Crop Name : $_cropName',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 50.0,
        ),
        Text(
          'Area : $_area Acres',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 50.0,
        ),
        const Text(
          'Plants :',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          children: List.generate(
            _plantList.length,
            (index) => ListTile(
              title: Text(
                '${_plantList.elementAt(index)}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        )
      ],
    );

class CropRecord {
  final String name;
  final String area;
  final List<dynamic> plants;

  CropRecord.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['area'] != null),
        assert(map['plants'] != null),
        name = map['name'] as String,
        area = map['area'] as String,
        plants = map['plants'] as List<dynamic>;
}
