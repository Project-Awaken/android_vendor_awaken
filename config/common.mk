include vendor/awaken/build/core/vendor/*.mk
include vendor/awaken/config/gsm.mk

# Inherit from textclassifier config
$(call inherit-product, vendor/awaken/config/textclassifier.mk)

ifeq ($(USE_GAPPS),true)
$(call inherit-product, vendor/gapps/gapps.mk)
endif

ifeq ($(TARGET_SUPPORTS_UPDATABLE_APEX),true)
$(call inherit-product, vendor/prebuilts/config/apex.mk)
endif

ifeq ($(PRODUCT_USES_QCOM_HARDWARE), true)
include vendor/awaken/build/core/ProductConfigQcom.mk
endif

$(call inherit-product, vendor/qcom/opensource/power/power-vendor-board.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_USES_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.sys.disable_rescue=true \
    ro.build.selinux=1

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/awaken/build/tools/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/awaken/build/tools/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/awaken/build/tools/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# copy privapp permissions
PRODUCT_COPY_FILES += \
    vendor/awaken/prebuilt/common/etc/permissions/privapp-permissions-awaken-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-awaken-product.xml \
    vendor/awaken/prebuilt/common/etc/permissions/privapp-permissions-awaken-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-awaken-system.xml

# system mount
PRODUCT_COPY_FILES += \
    vendor/awaken/build/tools/system-mount.sh:install/bin/system-mount.sh

# backuptool
PRODUCT_COPY_FILES += \
    vendor/awaken/build/tools/backuptool.sh:$(TARGET_COPY_OUT_SYSTEM)/install/bin/backuptool.sh \
    vendor/awaken/build/tools/backuptool.functions:$(TARGET_COPY_OUT_SYSTEM)/install/bin/backuptool.functions \
    vendor/awaken/build/tools/50-awaken.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-awaken.sh

# Awaken-specific init file
PRODUCT_COPY_FILES += \
    vendor/awaken/prebuilt/common/etc/init.awaken.rc:system/etc/init/init.awaken.rc

# Build ID
PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID="$(BUILD_ID)-$(TARGET_BUILD_VARIANT)"

# Packages
include vendor/awaken/config/packages.mk

# Branding
include vendor/awaken/config/branding.mk

# Sounds
include vendor/awaken/config/pixel2-audio_prebuilt.mk

# Bootanimation
include vendor/awaken/config/bootanimation.mk

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := true
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# Fonts
include vendor/awaken/config/fonts.mk

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/awaken/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/awaken/overlay/common
