# euclidOS packages
PRODUCT_PACKAGES += \
    Etar \
    euclidOSSetupWizard \
    ExactCalculator \
    Glimpse \
    Datura 

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

TORCH_STR_SUPPORTED ?= false

PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.torch_str_support=$(TORCH_STR_SUPPORTED)
