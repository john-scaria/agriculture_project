import 'package:agriculture_project/bloc/qrfire_bloc/qrfire_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantBody extends StatefulWidget {
  @override
  _PlantBodyState createState() => _PlantBodyState();
}

class _PlantBodyState extends State<PlantBody> {
  Future<void> _scanQR() async {
    String qrScanRes = '-1';
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      BlocProvider.of<QrfireBloc>(context).add(
        QrScanned(
          qCode: qrScanRes,
        ),
      );
    }
    if (!mounted) return;
    BlocProvider.of<QrfireBloc>(context).add(
      QrScanned(
        qCode: qrScanRes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 50.0,
            left: 10.0,
            right: 10.0,
            bottom: 50.0,
          ),
          child: Center(
            child: BlocBuilder<QrfireBloc, QrfireState>(
              builder: (context, state) {
                if (state is QrSuccess) {
                  return _resultBuilder(context, state.qCode);
                }
                if (state is QrfireInitial) {
                  return Text(state.message);
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
        Positioned(
          right: 10.0,
          bottom: 10.0,
          child: FloatingActionButton(
            onPressed: () => _scanQR(),
            child: const Icon(
              Icons.qr_code_scanner,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _resultBuilder(BuildContext context, String value) {
  if (value.isEmpty || value == null) {
    return const Text(
      'Scan to Get Details!!',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  try {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('plants');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(value).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Data not Available!!"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          try {
            final Map<String, dynamic> data = snapshot.data.data();
            final PlantRecord plantRecord = PlantRecord.fromMap(data);
            final List<Medicine> _medicineList = plantRecord.medicine.entries
                .map((e) => Medicine(medName: e.key, medLink: e.value))
                .toList();
            if (data == null || data.isEmpty) {
              return const Center(child: Text('Data not Available!!'));
            }
            return _plantResultDisplay(
              _medicineList,
              plantRecord.name,
              plantRecord.description,
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
    return const Text("Error Occured");
  } catch (_) {
    return const Text("Error Occured");
  }
}

Widget _plantResultDisplay(
        List<Medicine> _medList, String _plantName, String _plantDes) =>
    ListView(
      children: [
        Text(
          'Plant Name : $_plantName',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 50.0,
        ),
        const Text(
          'Description :',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _plantDes,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 50.0,
        ),
        const Text(
          'Products :',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          children: List.generate(
            _medList.length,
            (index) => ListTile(
              title: Text(
                _medList.elementAt(index).medName,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: const Icon(Icons.shopping_basket),
              onTap: () async {
                final link = _medList.elementAt(index).medLink as String;
                if (await canLaunch(link)) {
                  await launch(link);
                } else {
                  return;
                }
              },
            ),
          ),
        ),
      ],
    );

class PlantRecord {
  final String name;
  final String description;
  final Map<String, dynamic> medicine;

  PlantRecord.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['description'] != null),
        assert(map['medicine'] != null),
        name = map['name'] as String,
        description = map['description'] as String,
        medicine = map['medicine'] as Map<String, dynamic>;
}

class Medicine {
  final String medName;
  final dynamic medLink;
  Medicine({@required this.medName, @required this.medLink});
}
