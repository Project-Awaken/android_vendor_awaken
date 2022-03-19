# Bootanimation
ifneq ($(filter $(TARGET_BOOT_ANIMATION_RES),720 1080 1440),)
     PRODUCT_COPY_FILES += vendor/awaken/prebuilt/bootanimation/bootanimation_$(TARGET_BOOT_ANIMATION_RES).zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else
    $(error "Invalid bootanimation resolution: $(TARGET_BOOT_ANIMATION_RES). Define TARGET_BOOT_ANIMATION_RES to 720/1080/1440.")
endif
