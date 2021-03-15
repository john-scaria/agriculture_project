import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'qrfire_event.dart';
part 'qrfire_state.dart';

class QrfireBloc extends Bloc<QrfireEvent, QrfireState> {
  QrfireBloc()
      : super(
          QrfireInitial(
            message: 'Scan To Get Data',
          ),
        );

  @override
  Stream<QrfireState> mapEventToState(
    QrfireEvent event,
  ) async* {
    if (event is QrScanned) {
      if (event.qCode == '-1') {
        yield QrfireInitial(
          message: 'Scan To Get Data',
        );
      } else {
        yield QrSuccess(
          qCode: event.qCode,
        );
      }
    }
    if (event is QrInitFire) {
      yield QrfireInitial(
        message: 'Scan To Get Data',
      );
    }
  }
}
