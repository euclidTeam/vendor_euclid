# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
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

# -----------------------------------------------------------------
# Lineage OTA update package
ifeq ($(EUCLID_ZIP_TYPE), Gapps)
EUCLID_TARGET_PACKAGE := $(PRODUCT_OUT)/euclidOS-$(EUCLID_VERSION)-Gapps.zip
else
EUCLID_TARGET_PACKAGE := $(PRODUCT_OUT)/euclidOS-$(EUCLID_VERSION)-Vanilla.zip
endif

EUCLID_OTA_PACKAGE := euclidOS-$(EUCLID_VERSION)-$(EUCLID_ZIP_TYPE).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: euclid
euclid: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
        $(hide) ./vendor/euclid/build/tasks/ascii_output.sh
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EUCLID_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EUCLID_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(EUCLID_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/euclid/build/tools/generate_json_build_info.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(EUCLID_OTA_PACKAGE)
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	echo -e ${CL_BLD}${CL_GRN}"Zip: "${CL_RED} $(EUCLID_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"SHA256: "${CL_RED}" `cat $(EUCLID_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Size:"${CL_RED}" `du -sh $(EUCLID_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"TimeStamp:"${CL_RED}" `cat $(PRODUCT_OUT)/system/build.prop | grep ro.euclid.build.date | cut -d'=' -f2 | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Integer Value:"${CL_RED}" `wc -c $(EUCLID_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_RED}"================================================================================"${CL_RED}
