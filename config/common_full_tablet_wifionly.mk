# Inherit mobile full common euclidOS stuff
$(call inherit-product, vendor/euclid/config/common_mobile_full.mk)

# Inherit tablet common euclidOS stuff
$(call inherit-product, vendor/euclid/config/tablet.mk)

$(call inherit-product, vendor/euclid/config/wifionly.mk)
