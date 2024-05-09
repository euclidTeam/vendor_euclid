# Copyright (C) 2024 euclidOS
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

ANDROID_VERSION := 14
EUCLIDVERSION := 1.0

EUCLID_BUILD_TYPE ?= UNOFFICIAL
EUCLID_MAINTAINER ?= UNKNOWN
EUCLID_DATE_YEAR := $(shell date -u +%Y)
EUCLID_DATE_MONTH := $(shell date -u +%m)
EUCLID_DATE_DAY := $(shell date -u +%d)
EUCLID_DATE_HOUR := $(shell date -u +%H)
EUCLID_DATE_MINUTE := $(shell date -u +%M)
EUCLID_BUILD_DATE := $(EUCLID_DATE_YEAR)$(EUCLID_DATE_MONTH)$(EUCLID_DATE_DAY)-$(EUCLID_DATE_HOUR)$(EUCLID_DATE_MINUTE)
TARGET_PRODUCT_SHORT := $(subst euclid_,,$(EUCLID_BUILD))

# OFFICIAL_DEVICES
ifeq ($(EUCLID_BUILD_TYPE), OFFICIAL)
  LIST = $(shell cat vendor/euclid/config/euclid.devices)
    ifeq ($(filter $(EUCLID_BUILD), $(LIST)), $(EUCLID_BUILD))
      IS_OFFICIAL=true
      EUCLID_BUILD_TYPE := OFFICIAL
    endif
    ifneq ($(IS_OFFICIAL), true)
      EUCLID_BUILD_TYPE := UNOFFICIAL
      $(error Device is not official "$(EUCLID_BUILD)")
    endif
endif

EUCLID_VERSION := $(EUCLIDVERSION)-$(EUCLID_BUILD)-$(EUCLID_BUILD_DATE)-VANILLA-$(EUCLID_BUILD_TYPE)
ifeq ($(WITH_GAPPS), true)
EUCLID_VERSION := $(EUCLIDVERSION)-$(EUCLID_BUILD)-$(EUCLID_BUILD_DATE)-GAPPS-$(EUCLID_BUILD_TYPE)
endif
EUCLID_MOD_VERSION :=$(ANDROID_VERSION)-$(EUCLIDVERSION)
EUCLID_DISPLAY_VERSION := EuclidOS-$(EUCLIDVERSION)-$(EUCLID_BUILD_TYPE)
EUCLID_DISPLAY_BUILDTYPE := $(EUCLID_BUILD_TYPE)
EUCLID_FINGERPRINT := EuclidOS/$(EUCLID_MOD_VERSION)/$(TARGET_PRODUCT_SHORT)/$(EUCLID_BUILD_DATE)

# EUCLID System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.euclid.version=$(EUCLID_DISPLAY_VERSION) \
  ro.euclid.build.status=$(EUCLID_BUILD_TYPE) \
  ro.modversion=$(EUCLID_MOD_VERSION) \
  ro.euclid.build.date=$(EUCLID_BUILD_DATE) \
  ro.euclid.buildtype=$(EUCLID_BUILD_TYPE) \
  ro.euclid.fingerprint=$(EUCLID_FINGERPRINT) \
  ro.euclid.device=$(EUCLID_BUILD) \
  org.euclid.version=$(EUCLIDVERSION) \
  ro.euclid.maintainer=$(EUCLID_MAINTAINER)
