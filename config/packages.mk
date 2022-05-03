# Awaken packages
PRODUCT_PACKAGES += \
    ThemePicker \
    TouchGestures \
    RepainterServicePriv

ifneq ($(USE_GAPPS),true)
PRODUCT_PACKAGES += \
    Apps \
    Backgrounds \
    Eleven \
    Etar \
    ExactCalculator \
    GmsCompat \
    Jelly \
    Seedvault
endif

# Extra tools in Awaken
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    zip

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync
