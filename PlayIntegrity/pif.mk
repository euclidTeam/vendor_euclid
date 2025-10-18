# PIF values
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_MANUFACTURER?=Google \
    persist.sys.pihooks_BRAND?=google \
    persist.sys.pihooks_PRODUCT?=husky_beta \
    persist.sys.pihooks_DEVICE?=husky \
    persist.sys.pihooks_ID?=BP41.250822.010 \
    persist.sys.pihooks_RELEASE?=12 \
    persist.sys.pihooks_SECURITY_PATCH?=2025-09-05 \
    persist.sys.pihooks_DEVICE_INITIAL_SDK_INT?=21 \
    persist.sys.pihooks_SDK_INT?=32

PRODUCT_BUILD_PROP_OVERRIDES += \
    PihooksGmsFp="google/husky_beta/husky:16/BP41.250822.010/14082742:user/release-keys" \
    PihooksGmsModel="Pixel 8 Pro"
