#!/bin/bash
# Copyright (c) 2022 Huawei Device Co., Ltd.
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

# 下载google工具集depot_tools

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# 配置环境变量

export PATH="$PATH:${HOME}/depot_tools"

# 下载代码

fetch --nohooks chromium

cd src

git fetch origin 91.0.4455.0

git checkout -b 91.0.4455.0 FETCH_HEAD

gclient sync --with_branch_heads -D

# 下载依赖
./build/install-build-deps.sh --no-chromeos-fonts
./build/install-build-deps-android.sh

gclient runhooks

# 使用Openharmony nweb的patch

# 1.使用针对cef的修改
git apply ../patch/0001_cef_V4455.patch

# 2.使用针对openharmony编译的修改
git apply ../patch/0002_build_for_ohos.patch

# 3.使用nweb引擎的修改
git apply ../patch/0003_ohos_nweb.patch

# 4.chromium cve安全漏洞补丁及nweb bug修复
git apply ../patch/0004_nweb_cve_bugfix.patch
