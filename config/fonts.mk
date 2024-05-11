# google-sans family
PRODUCT_PACKAGES += \
    GoogleSans-Italic.ttf \
    GoogleSans-Regular.ttf \
    GoogleSansClock-Regular.ttf \
    GoogleSansFlex-Regular.ttf

# General Sans
PRODUCT_PACKAGES += \
    GeneralSans-Bold.ttf \
    GeneralSans-BoldItalic.ttf \
    GeneralSans-Italic.ttf \
    GeneralSans-Medium.ttf \
    GeneralSans-Regular.ttf \
    GeneralSans-MediumItalic.ttf

# Customization overlays
PRODUCT_PACKAGES += \
    FontGInterOverlay \
    FontGoogleSansOverlay \
    FontManropeOverlay \

PRODUCT_PACKAGES += \
    GInterVF-Italic.ttf \
    GInterVF-Roman.ttf \
    Manrope-VF.ttf \

# Register vendor fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/euclid/fonts/prebuilt,$(TARGET_COPY_OUT_PRODUCT)/fonts) \
    vendor/euclid/fonts/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml
