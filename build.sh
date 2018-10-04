#!/bin/bash

archs=(
  "linux32"
  "linux64"
  "win32"
  "win64"
)

prefix=(
  ""
  ""
  "i686-w64-mingw32-"
  "x86_64-w64-mingw32-"
)

ccflags=(
  "-m32"
  "-m64"
  "-m32"
  "-m64"
)

rm -rf "./obj"
rm -rf "./lib"

for i in ${!archs[@]}; do
  mkdir -p "obj/${archs[$i]}"
  mkdir -p "lib/${archs[$i]}"

  ${prefix[$i]}gcc ${ccflags[$i]} -Iinclude -c src/glad.c -o obj/${archs[$i]}/glad.o
  ${prefix[$i]}ar crs lib/${archs[$i]}/libglad-static.a obj/${archs[$i]}/glad.o
  ${prefix[$i]}strip --strip-unneeded lib/${archs[$i]}/libglad-static.a
done
