import 'package:dart_io_ffi/native_file_reader.dart';

void main(List<String> arguments) {
  final fileReader = NativeFileReader();

  if (arguments.isEmpty) {
    print('Usage: dart run bin/main.dart <file_path>');
    print('Example: dart run bin/main.dart README.md');
    return;
  }

  final filePath = arguments[0];

  print('Attempting to read file: $filePath');

  if (!fileReader.fileExists(filePath)) {
    print('Error: File does not exist: $filePath');
    return;
  }

  final content = fileReader.readFile(filePath);

  if (content != null) {
    print('File read successfully!');
    print('Content length: ${content.length} characters');
    print('\n${'-' * 20} File Content ${'-' * 20}');
    print(content);
  } else {
    print('Error: Failed to read file content');
  }
}
