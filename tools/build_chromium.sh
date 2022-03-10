#!/bin/bash
# Copyright (c) 2021 Huawei Device Co., Ltd.    
# Licensed under the Apache License, Version 2.0 (the "License");    
# you may not use this file except in compliance with the License.    
# You may obtain a copy of the License at    
#    
#     http://www.apache.org/licenses/LICENSE-2.0    
#    
# Unless required by applicable law or agreed to in writing, software    
# distributed under the License is distributed on an "AS IS" BASIS,    
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    
# See the License for the specific language governing permissions and    
# limitations under the License.

set -e
basedir=`dirname "$0"`

# following args will passed here by command line

#Add build args begin
buildargs="
  target_os=\"ohos\"
  target_cpu=\"arm\"
  is_debug=false
  enable_remoting=true
  use_allocator=\"none\"
  is_official_build=true
  is_component_build=false
  enable_nacl=false
  is_chrome_branded=false
  use_official_google_api_keys=false
  use_ozone=true
  use_aura=true
  ozone_auto_platforms=false
  ozone_platform=\"headless\"
  ozone_platform_headless=true
  enable_extensions=true
  ffmpeg_branding=\"Chrome\"
  use_kerberos=false
  use_bundled_fontconfig=true
  enable_resource_allowlist_generation=false
  enable_plugins=true
  clang_use_chrome_plugins=false
  toolkit_views=false
  enable_one_click_signin=true
  enable_message_center=true
  enable_offline_pages=false
  use_musl=true
  build_chromium_with_ohos_src=true
  safe_browsing_mode=0
  use_custom_libcxx=false
  use_sysroot=false
"
#Add build args end

buildgn=0
buildcount=0
buildccache=0
buildsymbol=0

while [ "$1" != "" ]; do
  case $1 in
    "-gn")
      buildgn=1
    ;;
    "-j")
      shift
      buildcount=$1
    ;;
    "-ccache")
      buildccache=1
    ;;
    "-sym")
      buildsymbol=1
    ;;
    *)
      echo " -> $1 <- is not a valid option, please follow the usage below: "
      echo "usage: ./build.sh [option]"
      echo "[option:]"
      echo "         -gn: build with generating gn files"
      echo "         -j N: force number of build jobs"
      echo "         -nosym: build without symbols"
      exit
    ;;
  esac
  shift
done

SYMBOL_LEVEL=0
if [ $buildsymbol = 1 ]; then
  SYMBOL_LEVEL=2
fi

if [ $buildcount = 0 ]; then
  buildcount=`grep processor /proc/cpuinfo | wc -l`
fi

if [ $buildccache = 1 ]; then
  if [ $buildcount = 0 ]; then
    buildcount=64
  fi
  GN_ARGS="cc_wrapper=\"ccache\" clang_use_chrome_plugins=false linux_use_bundled_binutils=false"
  export CCACHE_CPP2=yes
fi

cd src

time_start_for_build=`date +%s`
time_start_for_gn=$time_start_for_build

if [ $buildgn = 1 ]; then
  echo "generating args list: $buildargs $GN_ARGS"
  ./buildtools/linux64/gn gen out/Default --args="$buildargs $GN_ARGS symbol_level=$SYMBOL_LEVEL"
fi
time_end_for_gn=`date +%s`

./third_party/depot_tools/autoninja -C out/Default/ -j$buildcount libnweb_adapter libweb_engine
time_end_for_build=`date +%s`

time_format() {
  hours=$((($1 - $2) / 3600))
  minutes=$((($1 - $2) % 3600 / 60))
  seconds=$((($1 - $2) % 60))
}

time_format $time_end_for_gn $time_start_for_gn
printf "\n\e[32mTime for gn  : %dH:%dM:%dS \e[0m\n" $hours $minutes $seconds
time_format $time_end_for_build $time_end_for_gn
printf "\e[32mTime for build : %dH:%dM:%dS \e[0m\n" $hours $minutes $seconds
time_format $time_end_for_build $time_start_for_build
printf "\e[32mTime for Total : %dH:%dM:%dS \e[0m\n\n" $hours $minutes $seconds

echo "build done"
