# Inherit mobile full common euclid stuff
$(call inherit-product, vendor/euclid/config/common_mobile_full.mk)

# Inherit tablet common euclid stuff
$(call inherit-product, vendor/euclid/config/tablet.mk)

$(call inherit-product, vendor/euclid/config/telephony.mk)
