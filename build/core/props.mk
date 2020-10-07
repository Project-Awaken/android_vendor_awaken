# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

ADDITIONAL_BUILD_PROPERTIES += \
    ro.awaken.version=$(AWAKEN_BASE_VERSION)-$(AWAKEN_BUILD_TYPE)-$(BUILD_DATE)-$(BUILD_TIME) \
    ro.awaken.base.version=$(AWAKEN_BASE_VERSION) \
    ro.awaken.build.version=$(AWAKEN_PLATFORM_VERSION) \
    ro.awaken.codename=$(AWAKEN_CODENAME) \
    ro.awaken.build.type=$(AWAKEN_BUILD_TYPE) \
    ro.mod.version=$(BUILD_ID)-$(BUILD_DATE)-$(AWAKEN_BASE_VERSION) \
    ro.awaken.fingerprint=$(ROM_FINGERPRINT) \
    ro.awaken.buildtype=$(AWAKEN_BUILD_TYPE) \
    ro.awaken.device=$(TARGET_PRODUCT)
