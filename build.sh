#!/bin/bash

archs=(
  "linux32"
  "linux64"
  "win32"
  "win64"
)

hosts=(
  ""
  ""
  "i686-w64-mingw32"
  "x86_64-w64-mingw32"
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

  prefix=`[ ! -z ${hosts[$i]} ] && echo ${hosts[$i]}-`
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/gl.c -o obj/${archs[$i]}/gl.o
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/egl.c -o obj/${archs[$i]}/egl.o
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/vulkan.c -o obj/${archs[$i]}/vulkan.o
  ${prefix}ar crs lib/${archs[$i]}/libglad-static.a obj/${archs[$i]}/gl.o obj/${archs[$i]}/egl.o obj/${archs[$i]}/vulkan.o
  ${prefix}strip --strip-unneeded lib/${archs[$i]}/libglad-static.a
done
