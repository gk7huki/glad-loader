#!/bin/bash

HOST_arm=arm-linux-androideabi
CPPFLAGS_arm="-fpic -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -march=armv5te -mtune=xscale -msoft-float -fno-exceptions -mthumb -O2 -DNDEBUG -DANDROID -Wa,--noexecstack -fomit-frame-pointer -fno-strict-aliasing"
LDFLAGS_arm="-no-canonical-prefixes -march=armv5te -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel -mthumb"

HOST_armv7a=arm-linux-androideabi
CPPFLAGS_armv7a="-fpic -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -fno-exceptions -mthumb -O2 -DNDEBUG -DANDROID -Wa,--noexecstack -fomit-frame-pointer -fno-strict-aliasing"
LDFLAGS_armv7a="-no-canonical-prefixes -march=armv7-a -Wl,--fix-cortex-a8 -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel -mthumb"

HOST_arm64v8a=aarch64-linux-android
CPPFLAGS_arm64v8a="-fpic -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -fno-exceptions -O2 -DNDEBUG -DANDROID  -Wa,--noexecstack -fomit-frame-pointer -fstrict-aliasing -funswitch-loops"
LDFLAGS_arm64v8a="-no-canonical-prefixes -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel"

HOST_x86=i686-linux-android
CPPFLAGS_x86="-ffunction-sections -funwind-tables -no-canonical-prefixes -fstack-protector-strong -fno-exceptions -O2 -DNDEBUG -DANDROID -Wa,--noexecstack -mstackrealign -mstack-protector-guard=global -fomit-frame-pointer -fstrict-aliasing -funswitch-loops"
LDFLAGS_x86="-no-canonical-prefixes -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel"

HOST_x86_64=x86_64-linux-android
CPPFLAGS_x86_64="-ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -fno-exceptions -O2 -DNDEBUG -DANDROID -Wa,--noexecstack -fomit-frame-pointer -fstrict-aliasing -funswitch-loops"
LDFLAGS_x86_64="-no-canonical-prefixes -Wl,--build-id -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel"

archs=(
  "armeabi"
  "armeabi-v7a"
  "arm64-v8a"
  "x86"
  "x86_64"
)

hosts=(
  "$HOST_arm"
  "$HOST_armv7a"
  "$HOST_arm64v8a"
  "$HOST_x86"
  "$HOST_x86_64"
)

ccflags=(
  "$CPPFLAGS_arm"
  "$CPPFLAGS_armv7a"
  "$CPPFLAGS_arm64v8a"
  "$CPPFLAGS_x86"
  "$CPPFLAGS_x86_64"
)

rm -rf "./obj/android"
rm -rf "./lib/android"

for i in ${!archs[@]}; do
  mkdir -p "obj/android/${archs[$i]}"
  mkdir -p "lib/android/${archs[$i]}"

  prefix=`[ ! -z ${hosts[$i]} ] && echo ${hosts[$i]}-`
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/gl.c -o obj/android/${archs[$i]}/gl.o
  ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/egl.c -o obj/android/${archs[$i]}/egl.o

  if [ "${archs[$i]}" = "armeabi" ]; then
    ${prefix}ar crs lib/android/${archs[$i]}/libglad.a obj/android/${archs[$i]}/gl.o obj/android/${archs[$i]}/egl.o
  else
    ${prefix}gcc ${ccflags[$i]} -Iinclude -c src/vulkan.c -o obj/android/${archs[$i]}/vulkan.o
    ${prefix}ar crs lib/android/${archs[$i]}/libglad.a obj/android/${archs[$i]}/gl.o obj/android/${archs[$i]}/egl.o obj/android/${archs[$i]}/vulkan.o
  fi

  ${prefix}strip --strip-unneeded lib/android/${archs[$i]}/libglad.a
done
