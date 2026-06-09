import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';
import 'package:turso_dart/src/statement.dart';

class Transaction implements Finalizable {
  Transaction._(this._ptr) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
  }

  static final NativeFinalizer _finalizer = NativeFinalizer(
    Native.addressOf<NativeFunction<Void Function(Pointer<Void>)>>(
      g.transaction_dispose,
    ).cast(),
  );

  final Pointer<Void> _ptr;

  Statement prepare(String sql) {
    final result = g.transaction_prepare(_ptr, sql.toNativeUtf8().cast());
    final g.FFIResponse(:ptr, :error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
    return newStatement(ptr);
  }

  void commit() {
    final result = g.transaction_commit(_ptr);
    final g.FFIResponse(:error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
  }

  void rollback() {
    final result = g.transaction_rollback(_ptr);
    final g.FFIResponse(:error_message) = result;
    if (error_message.isNotEmpty) {
      throw Exception(error_message.toDartString());
    }
  }
}

Transaction newTransaction(Pointer<Void> ptr) => Transaction._(ptr);

enum TransactionBehavior {
  deferred,
  immediate,
  exclusive,
}
