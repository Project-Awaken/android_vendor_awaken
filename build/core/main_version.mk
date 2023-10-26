# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# AwakenOS System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.awaken.base.codename=$(AWAKEN_CODENAME) \
    ro.awaken.base.version=$(AWAKEN_NUM_VER) \
    ro.awaken.build.version=$(AWAKEN_BUILD_VERSION) \
    ro.awaken.build.date=$(BUILD_DATE) \
    ro.awaken.buildtype=$(AWAKEN_BUILD_TYPE) \
    ro.awaken.display.version=$(AWAKEN_DISPLAY_VERSION) \
    ro.awaken.fingerprint=$(ROM_FINGERPRINT) \
    ro.awaken.version=$(AWAKEN_VERSION) \
    ro.modversion=$(AWAKEN_VERSION)
