// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'dart:io' show Platform, Directory;

import 'package:path/path.dart' as path;

typedef TopFunc = Int64 Function();
typedef Top = int Function();

int connect() {
  var libraryPath =
      path.join(Directory.current.path, 'taskwire', 'lib.so');

  if (Platform.isMacOS) {
    libraryPath =
        path.join(Directory.current.path, 'taskwire', 'lib.dylib');
  }

  if (Platform.isWindows) {
    libraryPath = path.join(
        Directory.current.path, 'taskwire', 'lib.dll');
  }

  final lib = DynamicLibrary.open(libraryPath);

  final Top hello = lib
      .lookup<NativeFunction<TopFunc>>('Top')
      .asFunction();

  return hello();
}