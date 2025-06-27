#!/bin/bash

echo "Building native library..."
cd native
mkdir -p build

gcc -shared -fPIC -o build/libfile_reader.dylib file_reader.c
echo "Build completed!"

if [ -f "build/libfile_reader.dylib" ]; then
    echo -e "\nLibrary built successfully: native/build/libfile_reader.dylib"
else
    echo -e "\nLibrary build failed"
    exit 1
fi
