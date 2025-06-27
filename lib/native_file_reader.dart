import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef ReadFileC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ReadFileDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef FreeStringC = Void Function(Pointer<Utf8>);
typedef FreeStringDart = void Function(Pointer<Utf8>);

typedef FileExistsC = Int32 Function(Pointer<Utf8>);
typedef FileExistsDart = int Function(Pointer<Utf8>);

class NativeFileReader {
  late final DynamicLibrary _dylib;
  late final ReadFileDart _readFile;
  late final FreeStringDart _freeString;
  late final FileExistsDart _fileExists;

  NativeFileReader() {
    final libraryPath = _getLibraryPath();
    _dylib = DynamicLibrary.open(libraryPath);

    _readFile = _dylib
        .lookup<NativeFunction<ReadFileC>>('read_file')
        .asFunction<ReadFileDart>();

    _freeString = _dylib
        .lookup<NativeFunction<FreeStringC>>('free_string')
        .asFunction<FreeStringDart>();

    _fileExists = _dylib
        .lookup<NativeFunction<FileExistsC>>('file_exists')
        .asFunction<FileExistsDart>();
  }

  String _getLibraryPath() {
    final current = Directory.current;
    final libraryPath = path.join(
      current.path,
      'native',
      'build',
      'libfile_reader.dylib',
    );
    return libraryPath;
  }

  bool fileExists(String filePath) {
    final pathPtr = filePath.toNativeUtf8();
    try {
      final result = _fileExists(pathPtr);
      return result == 1;
    } finally {
      malloc.free(pathPtr);
    }
  }

  String? readFile(String filePath) {
    if (!fileExists(filePath)) {
      return null;
    }

    final pathPtr = filePath.toNativeUtf8();
    try {
      final resultPtr = _readFile(pathPtr);

      if (resultPtr == nullptr) {
        return null;
      }

      final content = resultPtr.toDartString();
      _freeString(resultPtr);

      return content;
    } finally {
      malloc.free(pathPtr);
    }
  }
}
