#!/bin/sh -e

if [ $(uname) = "Darwin" ]; then
	CMAKE_GENERATOR="Xcode"
	CMAKE_FLAGS="-DCMAKE_OSX_DEPLOYMENT_TARGET=10.11  \
                     -DCMAKE_OSX_ARCHITECTURES=\"x86_64\""
	GENERATOR_FLAGS=""
else
	CMAKE_GENERATOR="Unix Makefiles"
	CMAKE_FLAGS=""
	GENERATOR_FLAGS="-j8"
fi

ROOT_DIR=$(pwd)
BUILD_DIR=$ROOT_DIR/build
INSTALL_DIR=$ROOT_DIR/artifacts

cmake -E make_directory "$BUILD_DIR"
cmake -E chdir "$BUILD_DIR" cmake -G "$CMAKE_GENERATOR" $CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED=ON ..
cmake --build "$BUILD_DIR" --clean-first --config Release --target install -- $GENERATOR_FLAGS
cmake -E copy_directory "$ROOT_DIR/headers" "$INSTALL_DIR/include"
