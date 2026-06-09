import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';
import 'package:turso_dart/src/params.dart';

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

  List<Map<String, dynamic>> query({Params? params}) {
    final result = g.statement_query(
      _ptr,
      params?.encode()?.toNativeUtf8().cast() ?? nullptr,
    );
    final g.FFIStringResponse(:value, :error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
    final json = value.toDartString();
    final rows = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    return rows;
  }

  void execute({Params? params}) {
    final result = g.statement_execute(
      _ptr,
      params?.encode()?.toNativeUtf8().cast() ?? nullptr,
    );
    final g.FFIResponse(:error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
  }
}

Statement newStatement(Pointer<Void> ptr) => Statement._(ptr);
