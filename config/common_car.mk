# Inherit common Awaken stuff
$(call inherit-product, vendor/awaken/config/common.mk)

# Inherit Awaken car device tree
$(call inherit-product, device/awaken/car/awaken_car.mk)

# Inherit the main AOSP car makefile that turns this into an Automotive build
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
