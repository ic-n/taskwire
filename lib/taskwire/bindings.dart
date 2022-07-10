// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'dart:io' show Platform, Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef SingleCall = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

String singleCall(String user, String password, String dial, String cmd) {
  var libraryPath = path.join(Directory.current.path, 'taskwire', 'lib.so');

  if (Platform.isMacOS) {
    libraryPath = path.join(Directory.current.path, 'taskwire', 'lib.dylib');
  }

  if (Platform.isWindows) {
    libraryPath = path.join(Directory.current.path, 'taskwire', 'lib.dll');
  }

  final lib = DynamicLibrary.open(libraryPath);

  final SingleCall connect = lib.lookup<NativeFunction<SingleCall>>('SingleCall').asFunction();

  var rep = connect(user.toNativeUtf8(), password.toNativeUtf8(), dial.toNativeUtf8(), cmd.toNativeUtf8());

  return rep.toDartString();
}
