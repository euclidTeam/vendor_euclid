# Boot Animation

# 1440p
ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
PRODUCT_COPY_FILES += vendor/euclid/bootanimation/1440p.zip:system/media/bootanimation.zip
# 1080p
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
PRODUCT_COPY_FILES += vendor/euclid//bootanimation/1080p.zip:system/media/bootanimation.zip
# 720p
else ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
PRODUCT_COPY_FILES += vendor/euclid/bootanimation/720p.zip:system/media/bootanimation.zip
# Default to 1080p if the device does not set the flag.
else
PRODUCT_COPY_FILES += vendor/euclid/bootanimation/1080p.zip:system/media/bootanimation.zip
endif
