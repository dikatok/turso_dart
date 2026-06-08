import 'dart:async';
import 'dart:isolate';

import 'package:turso_dart/turso_dart_bindings_generated.dart' as bindings;

int sum(int a, int b) => bindings.sum(a, b);

Future<int> sumAsync(int a, int b) async {
  final helperIsolateSendPort = await _helperIsolateSendPort;
  final requestId = _nextSumRequestId++;
  final request = _SumRequest(requestId, a, b);
  final completer = Completer<int>();
  _sumRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

class _SumRequest {
  const _SumRequest(this.id, this.a, this.b);
  final int id;
  final int a;
  final int b;
}

class _SumResponse {
  const _SumResponse(this.id, this.result);
  final int id;
  final int result;
}

int _nextSumRequestId = 0;

final Map<int, Completer<int>> _sumRequests = <int, Completer<int>>{};

Future<SendPort> _helperIsolateSendPort = () async {
  final completer = Completer<SendPort>();

  final receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _SumResponse) {
        final completer = _sumRequests[data.id]!;
        _sumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  await Isolate.spawn((sendPort) async {
    final helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is _SumRequest) {
          final result = bindings.sum_long_running(data.a, data.b);
          final response = _SumResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  return completer.future;
}();
