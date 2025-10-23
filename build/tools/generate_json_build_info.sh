#!/bin/bash
#
# Copyright (C) 2025
# Project Euclid
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

# Usage: ./generate_ota_json.sh <device> <product_out> <filename>
# Silent, build-safe version for use inside Android.mk via $(hide)

DEVICE="$1"
PRODUCT_OUT="$2"
FILENAME="$3"

VERSION_MK="vendor/euclid/config/version.mk"
OTA_JSON="vendor/euclidOTA/builds/${DEVICE}.json"

# Extract values from version.mk
EUCLIDVERSION=$(awk '/EUCLIDVERSION :=/{print $3}' "$VERSION_MK")
EUCLID_BUILD_TYPE=$(awk '/EUCLID_BUILD_TYPE/{print $3}' "$VERSION_MK")
EUCLID_MAINTAINER=$(awk '/EUCLID_MAINTAINER/{print $3}' "$VERSION_MK")
EUCLID_CODENAME=$(awk '/EUCLID_CODENAME :=/{print $3}' "$VERSION_MK")

# Extract build info
BUILD_PROP="$PRODUCT_OUT/system/build.prop"
TIMESTAMP=$(grep -m1 "ro.system.build.date.utc" "$BUILD_PROP" | cut -d '=' -f2)
OEM=$(grep -m1 "ro.product.manufacturer" "$BUILD_PROP" | cut -d '=' -f2)
DEVICE_NAME=$(grep -m1 "ro.product.device" "$BUILD_PROP" | cut -d '=' -f2)

MD5=$(md5sum "$PRODUCT_OUT/$FILENAME" | cut -d ' ' -f1)
SHA256=$(sha256sum "$PRODUCT_OUT/$FILENAME" | cut -d ' ' -f1)
DOWNLOAD="https://sourceforge.net/projects/euclidos-releases/files/Android-14/${DEVICE}/${FILENAME}/download"

# Create builds directory if missing
mkdir -p "$(dirname "$OTA_JSON")"

# If existing JSON present, extract old values
if [ -f "$OTA_JSON" ]; then
    OLD_MAINTAINER=$(grep -m1 '"maintainer"' "$OTA_JSON" | cut -d '"' -f4)
    OLD_OEM=$(grep -m1 '"oem"' "$OTA_JSON" | cut -d '"' -f4)
    OLD_FORUM=$(grep -m1 '"forum"' "$OTA_JSON" | cut -d '"' -f4)
    OLD_TELEGRAM=$(grep -m1 '"telegram"' "$OTA_JSON" | cut -d '"' -f4)
else
    OLD_MAINTAINER="$EUCLID_MAINTAINER"
    OLD_OEM="$OEM"
    OLD_FORUM="https://t.me/euclidcommunity"
    OLD_TELEGRAM="https://t.me/euclidosofficial"
fi

# Fallbacks if empty
MAINTAINER=${OLD_MAINTAINER:-$EUCLID_MAINTAINER}
OEM=${OLD_OEM:-$OEM}
FORUM=${OLD_FORUM:-https://t.me/euclidcommunity}
TELEGRAM=${OLD_TELEGRAM:-https://t.me/euclidosofficial}

# Write updated JSON atomically (no partials)
TMP_FILE="${OTA_JSON}.tmp"

cat > "$TMP_FILE" <<EOF
{
  "response": [
    {
      "maintainer": "${MAINTAINER}",
      "oem": "${OEM}",
      "device": "${DEVICE_NAME}",
      "version": "${EUCLIDVERSION}",
      "download": "${DOWNLOAD}",
      "timestamp": ${TIMESTAMP},
      "md5": "${MD5}",
      "sha256": "${SHA256}",
      "forum": "${FORUM}",
      "telegram": "${TELEGRAM}"
    }
  ]
}
EOF

mv -f "$TMP_FILE" "$OTA_JSON"