# Inherit common mobile Awaken stuff
$(call inherit-product, vendor/awaken/config/common.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_AWAKEN_CHARGER),false)
PRODUCT_PACKAGES += \
    awaken_charger_animation \
    awaken_charger_animation_vendor
endif

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
