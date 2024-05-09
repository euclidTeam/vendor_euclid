# Inherit common mobile euclid stuff
$(call inherit-product, vendor/euclid/config/common.mk)

# Include AOSP audio files
include vendor/euclid/config/aosp_audio.mk

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub
