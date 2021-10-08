include vendor/awaken/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/awaken/config/BoardConfigQcom.mk
endif

include vendor/awaken/config/BoardConfigSoong.mk
