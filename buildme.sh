#!/bin/bash

if [ -d build ]; then
	echo "found existing build directory. quiting"
	exit -1
fi

echo "creating build environment..."
mkdir build
if ! git submodule status buildroot| grep -q '^+'; then
	git submodule update --init buildroot
fi

echo "copying configurations..."
cp -r buildroot build
cp -r fenrirconfig build/buildroot
cp fenrirconfig/buildrootconfig build/buildroot/.config

echo "applying patches..."
pushd build/buildroot
for patchfile in $(find ../../patch -name '*.patch' -type f); do
	patch -p1 < "$patchfile";
done

echo "starting build..."
make
popd
echo "build done."
