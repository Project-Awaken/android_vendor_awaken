# Inherit full common Lineage stuff
$(call inherit-product, vendor/awaken/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/awaken/overlay/dictionaries

$(call inherit-product, vendor/awaken/config/telephony.mk)
