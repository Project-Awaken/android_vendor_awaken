# Set Awaken specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit full common Awaken stuff
$(call inherit-product, vendor/awaken/config/common_full_phone.mk)
