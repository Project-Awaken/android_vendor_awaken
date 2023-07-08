# Inherit common mobile Awaken stuff
$(call inherit-product, vendor/awaken/config/common.mk)

ifneq ($(TARGET_EXCLUDES_AUDIOFX),true)
PRODUCT_PACKAGES += \
    AudioFX
endif

# Camera
PRODUCT_PACKAGES += \
    Aperture

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
