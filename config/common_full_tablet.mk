# Inherit full common Awaken stuff
$(call inherit-product, vendor/awaken/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    androidx.window.extensions \
    LatinIME

# Include Awaken LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/awaken/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/awaken/overlay/dictionaries

$(call inherit-product, vendor/awaken/config/telephony.mk)
