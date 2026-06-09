import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension PointerCharExt on Pointer<Char> {
  bool get isEmpty => this == nullptr || toDartString().isEmpty;

  bool get isNotEmpty => !isEmpty;

  String toDartString() => cast<Utf8>().toDartString();
}
