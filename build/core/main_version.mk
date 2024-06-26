# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# euclidOS System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.modversion=$(EUCLID_VERSION)
