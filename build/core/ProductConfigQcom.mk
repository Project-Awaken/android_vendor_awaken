# Bring in Qualcomm helper macros
include vendor/awaken/build/core/utils.mk

A_FAMILY := msm7x27a msm7x30 msm8660 msm8960
B_FAMILY := msm8226 msm8610 msm8974
B64_FAMILY := msm8992 msm8994
BR_FAMILY := msm8909 msm8916
UM_3_18_FAMILY := msm8917 msm8937 msm8953 msm8996
UM_4_4_FAMILY := msm8998 sdm660
UM_4_9_FAMILY := sdm845
UM_4_14_FAMILY := $(MSMNILE) $(MSMSTEPPE) $(TRINKET) $(ATOLL)
UM_4_19_FAMILY := $(KONA) $(LITO)
UM_PLATFORMS := $(UM_3_18_FAMILY) $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY)
QSSI_SUPPORTED_PLATFORMS := $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_4_19_FAMILY)

BOARD_USES_ADRENO := true

# UM platforms no longer need this set on O+
ifneq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_QCOM_BSP := true
endif

# Tell HALs that we're compiling an AOSP build with an in-line kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

ifneq ($(filter msm7x27a msm7x30 msm8660 msm8960,$(PRODUCT_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_BSP_LEGACY := true
    # Enable legacy audio functions
    ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
        ifneq ($(filter msm8960,$(PRODUCT_BOARD_PLATFORM)),)
            USE_CUSTOM_AUDIO_POLICY := 1
        endif
    endif
endif

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Enable color metadata for all UM targets
ifeq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_COLOR_METADATA := true
endif

# Enable DRM PP driver on UM platforms that support it
ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY)),true)
    TARGET_USES_DRM_PP := true
endif

# List of targets that use master side content protection
MASTER_SIDE_CP_TARGET_LIST := msm8996 $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY)

# Every qcom platform is considered a vidc target
MSM_VIDC_TARGET_LIST := $(PRODUCT_BOARD_PLATFORM)

ifeq ($(call is-board-platform-in-list, $(A_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8960
else ifeq ($(call is-board-platform-in-list, $(B_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8974
else ifeq ($(call is-board-platform-in-list, $(B64_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8994
else ifeq ($(call is-board-platform-in-list, $(BR_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8916
else ifeq ($(call is-board-platform-in-list, $(UM_3_18_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8996
    TARGET_USES_QCOM_UM_3_18_FAMILY := true
else ifeq ($(call is-board-platform-in-list, $(UM_4_4_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8998
    TARGET_USES_QCOM_UM_4_4_FAMILY := true
else ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sdm845
    TARGET_USES_QCOM_UM_4_9_FAMILY := true
else ifeq ($(call is-board-platform-in-list, $(UM_4_14_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8150
    TARGET_USES_QCOM_UM_4_14_FAMILY := true
else ifeq ($(call is-board-platform-in-list, $(UM_4_19_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8250
    TARGET_USES_QCOM_UM_4_19_FAMILY := true
else
    QCOM_HARDWARE_VARIANT := $(PRODUCT_BOARD_PLATFORM)
endif

# Allow a device to manually override which HALs it wants to use
ifneq ($(OVERRIDE_QCOM_HARDWARE_VARIANT),)
QCOM_HARDWARE_VARIANT := $(OVERRIDE_QCOM_HARDWARE_VARIANT)
endif

# Required for frameworks/native
ifeq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_QCOM_UM_FAMILY := true
endif

PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)

# Add display-commonsys-intf to PRODUCT_SOONG_NAMESPACES for QSSI supported platforms
ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/commonsys-intf/display
endif

# Add data-ipa-cfg-mgr to PRODUCT_SOONG_NAMESPACES if needed
ifneq ($(USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR),true)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
endif

include vendor/awaken/build/core/qcom_target.mk
