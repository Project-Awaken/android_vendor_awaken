# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Awaken Packages
PRODUCT_PACKAGES += \
    CustomDoze \
    StitchImage \
    ThemePicker \
    PixelThemesStub2019 \
    MatchmakerPrebuilt \
    WallpaperPickerGoogle

# Custom Overlays
# Settings
PRODUCT_PACKAGES += \
    SystemPitchBlackOverlay \
    SystemUIPitchBlackOverlay \
    SystemDarkGrayOverlay \
    SystemUIDarkGrayOverlay \
    SystemStyleOverlay \
    SystemUIStyleOverlay \
    SystemNightOverlay \
    SystemUINightOverlay

# Local Updater
ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_PACKAGES += \
    LocalUpdater
endif

PRODUCT_PACKAGES += \
     AwakenOverlayStub

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

-include vendor/awaken/config/overlay.mk
