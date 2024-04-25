# Only include Updater for official  build
ifeq ($(filter-out OFFICIAL,$(EUCLID_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/euclid/prebuilt/common/etc/init/init.euclid-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.euclid-updater.rc
endif

