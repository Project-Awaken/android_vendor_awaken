# Copyright (C) 2016-2017 AOSiP
# Copyright (C) 2020 Fluid
# Copyright (C) 2021 AwakenOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Versioning System
AWAKEN_CODENAME := triton
AWAKEN_NUM_VER := 3.5

TARGET_PRODUCT_SHORT := $(subst awaken_,,$(AWAKEN_BUILD_TYPE))

AWAKEN_BUILD_TYPE ?= unofficial

# Only include Updater for official  build
ifeq ($(filter-out official,$(AWAKEN_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        Updater
endif

# Sign builds if building an official build
ifeq ($(filter-out official,$(AWAKEN_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
AWAKEN_BUILD_VERSION := $(AWAKEN_NUM_VER)-$(AWAKEN_CODENAME)
AWAKEN_VERSION := $(AWAKEN_BUILD_VERSION)-$(AWAKEN_BUILD)-$(AWAKEN_BUILD_TYPE)-vanilla-$(BUILD_TIME)-$(BUILD_DATE)
ifeq ($(USE_GAPPS), true)
AWAKEN_VERSION := $(AWAKEN_BUILD_VERSION)-$(AWAKEN_BUILD)-$(AWAKEN_BUILD_TYPE)-$(BUILD_TIME)-$(BUILD_DATE)
endif
ROM_FINGERPRINT := awaken/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(BUILD_TIME)
AWAKEN_DISPLAY_VERSION := $(AWAKEN_VERSION)
RELEASE_TYPE := $(AWAKEN_BUILD_TYPE)
