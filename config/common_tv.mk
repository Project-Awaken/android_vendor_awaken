# Inherit common Awaken stuff
$(call inherit-product, vendor/awaken/config/common.mk)

# Inherit Awaken atv device tree
$(call inherit-product, device/awaken/atv/awaken_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

# Awaken packages
PRODUCT_PACKAGES += \
    LineageCustomizer

PRODUCT_PACKAGE_OVERLAYS += vendor/awaken/overlay/tv
