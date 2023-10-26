# Set Awaken specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit mini common Awaken stuff
$(call inherit-product, vendor/awaken/config/common_mini_phone.mk)
