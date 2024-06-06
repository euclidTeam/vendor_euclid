# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= euclidOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

EUCLID_ZIP_TYPE := Vanilla

# Gapps
ifeq ($(EUCLID_GAPPS), true)
    $(call inherit-product, vendor/gms/common/common-vendor.mk)
    EUCLID_ZIP_TYPE := Gapps
    SystemUI_Clocks := false
    PRODUCT_PACKAGES += \
	OTAGapps

    # Remove vendor/SystemUIClocks if it exists
    ifeq ($(wildcard vendor/SystemUIClocks), vendor/SystemUIClocks)
        $(shell rm -rf vendor/SystemUIClocks)
    endif
else
    PRODUCT_PACKAGES += \
	OTAVanilla

    SystemUI_Clocks := true
    PRODUCT_PRODUCT_PROPERTIES += \
        setupwizard.theme=glif_v4 \

    $(call inherit-product-if-exists, vendor/SystemUIClocks/product.mk)

endif

# Google wallpaper Config
TARGET_INCLUDE_PIXEL_LAUNCHER ?= false
ifeq ($(TARGET_INCLUDE_PIXEL_LAUNCHER),true)
PRODUCT_PACKAGES += \
    GappsFrameworks \
    GappsLauncherOverlay \
    GappsSettings \
    GappsSystemUI

else
   PRODUCT_PACKAGES += \
      AOSPFrameworks \
      AOSPLauncherOverlay \
      AOSPSettings \
      AOSPSystemUI
endif



ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Workaround AOSP AM crash
PRODUCT_PROPERTY_OVERRIDES += \
    sys.fflag.override.settings_enable_monitor_phantom_procs=false

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.usb.config=adb
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.usb.config=none

# Disable extra StrictMode features on all non-eng builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/euclid/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/euclid/prebuilt/common/bin/50-euclid.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-euclid.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-euclid.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/euclid/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/euclid/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# DroidX-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/init/init.euclid-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.euclid-system_ext.rc

# GMS Permissions
PRODUCT_COPY_FILES += \
    vendor/euclid/config/permissions/privapp-permissions-gms.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-gms.xml

# App lock permission
PRODUCT_COPY_FILES += \
   vendor/euclid/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# # Some permissions
PRODUCT_COPY_FILES += \
    vendor/euclid/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml \
    vendor/euclid/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml \

PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/init/init.custom-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.custom-system_ext.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl


# Google Photos Pixel Exclusive XML
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/sysconfig/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Overlay
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# UDFPS Animations
EXTRA_UDFPS_ANIMATIONS ?= false
ifeq ($(EXTRA_UDFPS_ANIMATIONS),true)
PRODUCT_PACKAGES += \
    UdfpsResources
endif

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(EUCLID_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Themed Icon
$(call inherit-product, vendor/google/overlays/ThemeIcons/config.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Face Unlock
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
TARGET_FACE_UNLOCK_SUPPORTED ?= true

PRODUCT_PACKAGES += \
    AOSPASettingsOverlay

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif
endif

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Flags
PRODUCT_PACKAGES += \
    SystemUIFlagFlipper

# Storage manager
PRODUCT_SYSTEM_PROPERTIES += \
    ro.storage_manager.enabled=true

# Default wifi country code
PRODUCT_SYSTEM_PROPERTIES += \
    ro.boot.wificountrycode?=00

# Blurs
ifeq ($(TARGET_SUPPORTS_BLUR),true)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1 \
    ro.launcher.blur.appLaunch=0 \
    persist.sys.sf.disable_blurs=1
endif



# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep \
    Settings \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.feature.day_night_mode_enabled=true \

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/euclid/overlay/common

PRODUCT_PACKAGES += \
    NetworkStackOverlay \

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model


PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/euclid/build/target/product/security/euclid

# Themepicker
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub

# Apps
PRODUCT_PACKAGES += \
    Aperture \
    Etar \
    GameSpace \
    Glimpse \
    OmniJaws \
    OmniStyle \
    Recorder \
    ExactCalculator \
    euclidOSWallpaperStub \
    ParallelSpace \
    LatinIME \

PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/sysconfig/quick_tap.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/quick_tap.xml

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv

# TouchGestures
TARGET_SUPPORTS_TOUCHGESTURES ?= false
ifeq ($(TARGET_SUPPORTS_TOUCHGESTURES),true)
PRODUCT_PACKAGES += \
    TouchGestures \
    TouchGesturesSettingsOverlay
endif

# Inherit SystemUI Clocks if they exist
ifeq ($(SystemUI_Clocks),true)
$(call inherit-product-if-exists, vendor/SystemUIClocks/product.mk)
endif

# Audio
include vendor/euclid/config/audio.mk

# Themes
include packages/overlays/Themes/themes.mk

include vendor/euclid/config/ota.mk
include vendor/euclid/config/props.mk
include vendor/euclid/config/version.mk
include vendor/euclid/config/bootanimation.mk
include vendor/euclid/config/telephony.mk
include vendor/euclid/config/themes.mk
-include vendor/euclid-priv/keys/keys.mk
include vendor/prebuilds/prebuilds.mk
