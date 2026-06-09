import 'dart:convert';

import 'package:ffi/ffi.dart';
import 'package:turso_dart/src/config.dart';
import 'package:turso_dart/src/database.dart';
import 'package:turso_dart/src/ffi.g.dart' as g;
import 'package:turso_dart/src/helpers.dart';

Database connect(LocalDbConfig config) {
  g.init();
  final result = g.connect_local(jsonEncode(config).toNativeUtf8().cast());
  final g.FFIResponse(:ptr, :error_message) = result;
  if (error_message.isNotEmpty) {
    throw Exception(error_message.toDartString());
  }
  return newDatabase(ptr);
}

Database connectSync(SyncDbConfig config) {
  g.init();
  final result = g.connect_sync(jsonEncode(config).toNativeUtf8().cast());
  final g.FFIResponse(:ptr, :error_message) = result;
  if (error_message.isNotEmpty) {
    throw Exception(error_message.toDartString());
  }
  return newDatabase(ptr);
}
