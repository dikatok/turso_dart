import 'dart:convert';
import 'dart:ffi';

import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';

class Statement implements Finalizable {
  Statement._(this._ptr) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
  }

  static final NativeFinalizer _finalizer = NativeFinalizer(
    Native.addressOf<NativeFunction<Void Function(Pointer<Void>)>>(
      g.statement_dispose,
    ).cast(),
  );

  final Pointer<Void> _ptr;

  List<Map<String, dynamic>> query() {
    final result = g.statement_query(_ptr);
    final g.FFIStringResponse(:value, :error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
    final json = value.toDartString();
    final rows = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    return rows;
  }

  void execute() {
    final result = g.statement_execute(_ptr);
    final g.FFIResponse(:error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
  }
}

Statement newStatement(Pointer<Void> ptr) => Statement._(ptr);
