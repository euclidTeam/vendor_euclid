# Inherit mini common euclid stuff
$(call inherit-product, vendor/euclid/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/euclid/config/telephony.mk)
