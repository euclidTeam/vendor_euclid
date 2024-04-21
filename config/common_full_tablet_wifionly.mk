$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit full common euclid stuff
$(call inherit-product, vendor/euclid/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Settings
PRODUCT_PRODUCT_PROPERTIES += \
    persist.settings.large_screen_opt.enabled=true

# Include euclid LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/euclid/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/euclid/overlay/dictionaries
