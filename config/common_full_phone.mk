# Inherit full common Awaken stuff
$(call inherit-product, vendor/awaken/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Awaken LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/awaken/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/awaken/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/awaken/config/telephony.mk)
