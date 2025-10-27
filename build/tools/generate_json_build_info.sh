#!/bin/bash
#
# Copyright (C) 2025 euclidOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

# Usage: ./generate_ota_json.sh <device> <product_out> <filename>
# Safe for automated build use

DEVICE="$1"
PRODUCT_OUT="$2"
FILENAME="$3"

VERSION_MK="vendor/euclid/config/version.mk"
OTA_JSON="vendor/euclidOTA/builds/${DEVICE}.json"

# Extract basic version info from version.mk
EUCLIDVERSION=$(awk '/EUCLIDVERSION :=/{print $3}' "$VERSION_MK")

# Extract info from build.prop
BUILD_PROP="$PRODUCT_OUT/system/build.prop"
TIMESTAMP=$(grep -m1 "ro.system.build.date.utc" "$BUILD_PROP" | cut -d '=' -f2)
OEM=$(grep -m1 "ro.product.system.manufacturer" "$BUILD_PROP" | cut -d '=' -f2)
DEVICE_NAME=$(grep -m1 "ro.product.system.device" "$BUILD_PROP" | cut -d '=' -f2)
MAINTAINER=$(grep -m1 "ro.maintainer.name" "$BUILD_PROP" | cut -d '=' -f2)

# Fallback if empty maintainer
if [ -z "$MAINTAINER" ]; then
    MAINTAINER="Unknown"
fi

# --- Determine actual file path ---
if [ -f "$FILENAME" ]; then
    FILE_PATH="$FILENAME"
elif [ -f "$PRODUCT_OUT/$FILENAME" ]; then
    FILE_PATH="$PRODUCT_OUT/$FILENAME"
else
    echo "Error: Build zip not found at $FILENAME or $PRODUCT_OUT/$FILENAME" >&2
    exit 1
fi

MD5=$(md5sum "$FILE_PATH" | cut -d ' ' -f1)
SHA256=$(sha256sum "$FILE_PATH" | cut -d ' ' -f1)
DOWNLOAD="https://sourceforge.net/projects/euclidos-releases/files/Android-14/${DEVICE}/${FILENAME}/download"

# Create builds directory if missing
mkdir -p "$(dirname "$OTA_JSON")"

# If existing JSON present, extract old optional values
if [ -f "$OTA_JSON" ]; then
    OLD_FORUM=$(grep -m1 '"forum"' "$OTA_JSON" | cut -d '"' -f4)
    OLD_TELEGRAM=$(grep -m1 '"telegram"' "$OTA_JSON" | cut -d '"' -f4)
else
    OLD_FORUM="https://t.me/euclidcommunity"
    OLD_TELEGRAM="https://t.me/euclidosofficial"
fi

FORUM=${OLD_FORUM:-https://t.me/euclidcommunity}
TELEGRAM=${OLD_TELEGRAM:-https://t.me/euclidosofficial}

# Write JSON atomically
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