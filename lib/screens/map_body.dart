import 'package:agriculture_project/bloc/map_bloc/map_bloc.dart';
import 'package:agriculture_project/screens/crop_with_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

class MapBody extends StatefulWidget {
  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(
              height: 100.0,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<MapBloc>(context)
                              .add(FullMapEvent(animTitle: 'idle'));
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          child: const Center(
                            child: Text('F'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<MapBloc>(context).add(
                                  SingleMapEvent(
                                    animTitle: 'crop${index + 1}_anim',
                                    cropName: 'Crop ${index + 1}',
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                child: Center(
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _blocWidget(_size),
          ],
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
      BlocProvider.of<MapBloc>(context).add(
        QrMapEvent(
          qrCode: qrScanRes,
        ),
      );
    }
    if (!mounted) return;
    BlocProvider.of<MapBloc>(context).add(
      QrMapEvent(
        qrCode: qrScanRes,
      ),
    );
  }

  Widget _blocWidget(Size _size) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapInitial) {
          return _dataWidgets(_size, state.artboard, 'Full Crop');
        }
        if (state is FullMapLoad) {
          return _dataWidgets(_size, state.artboard, 'Full Crop');
        }
        if (state is SingleMapLoad) {
          return _dataWidgets(_size, state.artboard, state.cropName);
        }
        if (state is QrSuccessMapLoad) {
          return CropWithDetails(
            value: state.qCode,
            size: _size,
            artboard: state.artboard,
          );
        }
        if (state is QrFailMapLoad) {
          return ScanErrorDisplay(
            size: _size,
            message: state.message,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Column _dataWidgets(Size _size, Artboard _artboard, String _cropName) {
    return Column(
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
        SizedBox(
          child: Center(
            child: Text(
              _cropName,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ScanErrorDisplay extends StatelessWidget {
  final Size size;
  final String message;
  const ScanErrorDisplay({
    @required this.size,
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
