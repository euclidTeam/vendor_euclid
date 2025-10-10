# euclidOS packages
PRODUCT_PACKAGES += \
    Etar \
    euclidOSSetupWizard \
    ExactCalculator \
    Glimpse 

ifneq ($(PRODUCT_NO_CAMERA),true)
PRODUCT_PACKAGES += \
    Aperture
endif

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Extra tools in euclid
PRODUCT_PACKAGES += \
    awk \
    bzip2 \
    curl \
    getcap \
    libsepol \
    setcap \

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    mke2fs \
    mkfs.exfat