include vendor/euclid/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/euclid/config/BoardConfigQcom.mk
endif

include vendor/euclid/config/BoardConfigSoong.mk
