# FFI File IO

A Dart console application that demonstrates Foreign Function Interface (FFI) by reading text files using native C APIs. This project showcases how to bridge Dart and C code to perform file I/O operations using low-level POSIX system calls.

## Features

- **Native File Reading**: Uses POSIX APIs (`open`, `read`, `fstat`) for file operations
- **FFI Integration**: Seamless bridge between Dart and C code using `dart:ffi`
- **Memory Management**: Proper allocation and cleanup with automatic memory management
- **File Validation**: Built-in file existence checking using `access()` system call
- **Error Handling**: Comprehensive error handling for file operations and edge cases
- **Cross-Platform**: Designed for macOS but easily adaptable to other Unix-like systems

## Project Structure

```
dart_io_ffi/
├── bin/
│   └── main.dart              # Main application entry point
├── lib/
│   └── native_file_reader.dart # Dart FFI wrapper class
├── native/
│   ├── file_reader.c          # C implementation of file operations
│   ├── file_reader.h          # C header file with function declarations
│   └── build/
│       └── libfile_reader.dylib # Compiled shared library
├── build.sh                   # Build script for the native library
├── pubspec.yaml              # Dart package configuration
└── README.md                 # This file
```

## Dependencies

- **Dart SDK**: ^3.5.3
- **ffi**: ^2.1.3 - For Foreign Function Interface support
- **path**: ^1.8.0 - For cross-platform path manipulation

## Building and Running

### 1. Build the Native Library

First, compile the C code into a shared library:

```bash
./build.sh
```

This will create `native/build/libfile_reader.dylib` on macOS.

### 2. Install Dart Dependencies

```bash
dart pub get
```

### 3. Run the Application

```bash
dart run bin/main.dart <file_path>
```

**Example:**

```bash
dart run bin/main.dart README.md
dart run bin/main.dart pubspec.yaml
```

## How It Works

### C Implementation (`native/file_reader.c`)

The C code provides three main functions:

- `read_file(const char *file_path)`: Opens a file, reads its contents, and returns a malloc'd string
- `file_exists(const char *file_path)`: Checks if a file exists using the `access()` system call
- `free_string(char *str)`: Properly frees memory allocated by `read_file`

### Dart FFI Wrapper (`lib/native_file_reader.dart`)

The `NativeFileReader` class:

1. Loads the shared library dynamically
2. Maps C functions to Dart function signatures
3. Handles string conversion between Dart and C
4. Manages memory allocation and cleanup
5. Provides a clean Dart API for file operations

### Main Application (`bin/main.dart`)

- Accepts a file path as a command-line argument
- Validates file existence before attempting to read
- Displays file content and metadata
- Handles errors gracefully

## Technical Details

### FFI Function Signatures

```dart
typedef ReadFileC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef FileExistsC = Int32 Function(Pointer<Utf8>);
typedef FreeStringC = Void Function(Pointer<Utf8>);
```

### Memory Management

- C functions allocate memory using `malloc()`
- Dart code ensures proper cleanup by calling `free_string()`
- Native UTF-8 strings are converted to Dart strings safely
- All temporary pointers are freed in `finally` blocks

## Error Handling

The application handles various error conditions:

- Non-existent files
- Permission errors
- Memory allocation failures
- Invalid file paths
- System call failures

## Platform Notes

- **macOS**: Uses `.dylib` shared libraries
- **Linux**: Would use `.so` shared libraries
- **Windows**: Would use `.dll` dynamic libraries

To adapt for other platforms, modify the library extension in `_getLibraryPath()` and update the build script accordingly.
