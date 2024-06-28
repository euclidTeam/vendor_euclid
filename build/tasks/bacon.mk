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
# euclidOS OTA update package

EUCLID_TARGET_PACKAGE := $(PRODUCT_OUT)/euclidOS-$(EUCLID_VERSION).zip
EUCLID_OTA_PACKAGE := euclidOS-$(EUCLID_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: euclid
euclid: $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ./vendor/euclid/build/tasks/ascii_output.sh
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EUCLID_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EUCLID_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(EUCLID_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/euclid/build/tools/generate_json_build_info.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(EUCLID_OTA_PACKAGE)
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	echo -e ${CL_BLD}${CL_CYN}"Timestamp:"${CL_PRP}" `cat $(PRODUCT_OUT)/system/build.prop | grep ro.build.date.utc | cut -d'=' -f2 | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Size:"${CL_PRP}" `du -sh $(EUCLID_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filehash: "${CL_PRP}" `md5sum $(EUCLID_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filename: "${CL_PRP} $(EUCLID_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"ID: "${CL_PRP}" `cat $(EUCLID_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_RED}"================================================================================"${CL_RED}
