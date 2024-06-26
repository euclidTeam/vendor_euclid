# Inherit full common euclidOS stuff
$(call inherit-product, vendor/euclid/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include euclid LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/euclid/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/euclid/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/euclid/config/telephony.mk)
