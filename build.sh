#!/bin/bash

arch=${1#--}

archs=(
  "linux32"
  "linux64"
  "linuxarmhf"
  "linuxarm64"
  "win32"
  "win64"
)

hosts=(
  ""
  ""
  "arm-linux-gnueabihf"
  "aarch64-linux-gnu"
  "i686-w64-mingw32"
  "x86_64-w64-mingw32"
)

ccflags=(
  "-m32"
  "-m64"
  ""
  ""
  ""
  ""
)

for i in ${!archs[@]}; do
  if [ ! -z ${arch} ] && [ ! ${archs[$i]} = ${arch} ]; then
    continue
  fi
  mkdir -p "build_${archs[$i]}"
  prefix=`[ ! -z ${hosts[$i]} ] && echo ${hosts[$i]}-`
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/gl.c -o build_${archs[$i]}/gl.o
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/egl.c -o build_${archs[$i]}/egl.o
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/vulkan.c -o build_${archs[$i]}/vulkan.o
  ${prefix}ar crs build_${archs[$i]}/libglad-static.a build_${archs[$i]}/gl.o build_${archs[$i]}/egl.o build_${archs[$i]}/vulkan.o
  ${prefix}strip --strip-unneeded build_${archs[$i]}/libglad-static.a
done
