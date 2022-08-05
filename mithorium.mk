#
# Copyright (C) 2022 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit AOSP product makefiles
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Crypto
ifeq ($(MITHORIUM_INCLUDE_CRYPTO_FBE),true)
MITHORIUM_INCLUDE_CRYPTO := true
PRODUCT_PACKAGES += qcom_decrypt_fbe
endif
ifeq ($(MITHORIUM_INCLUDE_CRYPTO_FDE),true)
MITHORIUM_INCLUDE_CRYPTO := true
endif
ifeq ($(MITHORIUM_INCLUDE_CRYPTO),true)
PRODUCT_PACKAGES += qcom_decrypt
ifeq ($(MITHORIUM_LEGACY_CRYPTO),true)
MITHOROUM_KEYMASTER_VERSION := 3.0
else # MITHORIUM_LEGACY_CRYPTO
MITHOROUM_KEYMASTER_VERSION ?= 4.0
endif # MITHORIUM_LEGACY_CRYPTO
endif # MITHORIUM_INCLUDE_CRYPTO

# Debug
PRODUCT_PACKAGES += \
    crash_dump \
    libprocinfo.recovery

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump32:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump32 \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump64:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump64

# Gatekeeper
ifeq ($(MITHORIUM_LEGACY_CRYPTO),true)
ifeq ($(MITHORIUM_INCLUDE_CRYPTO_FBE),true)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/bin/hw/android.hardware.gatekeeper@1.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.gatekeeper@1.0-service \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/hw/android.hardware.gatekeeper@1.0-impl.so
endif
endif

# Keymaster
ifeq ($(MITHORIUM_LEGACY_CRYPTO),true)
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/lib64/libkeymaster3device.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster3device.so \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/bin/hw/android.hardware.keymaster@3.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@3.0-service \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/hw/android.hardware.keymaster@3.0-impl.so
endif

# Proprietary - QSEECOMd
ifeq ($(MITHORIUM_INCLUDE_CRYPTO),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qseecomd/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
