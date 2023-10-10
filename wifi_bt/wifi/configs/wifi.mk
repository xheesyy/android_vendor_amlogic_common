#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
include vendor/amlogic/common/wifi_bt/wifi/configs/4_9/config.mk
else
include vendor/amlogic/common/wifi_bt/wifi/configs/5_4/config.mk
endif
-include device/khadas/$(PRODUCT_DIR)/wifibt.build.config.trunk.mk
WIFI_MODULES := $(CONFIG_WIFI_MODULES)
build_drivers :=\
$(foreach driver,\
 $(WIFI_SUPPORT_DRIVERS),\
 $(if $(filter true,$($(driver)_build)),$(driver)))
build_modules :=\
$(foreach driver,\
 $(build_drivers),\
 $($(driver)_modules))
ifeq ($(WIFI_MODULES), multiwifi)
WIFI_MODULES := $(build_modules)
endif
ifeq ($(WIFI_MODULES), )
WIFI_MODULES := $(build_modules)
else
$(foreach module,\
 $(WIFI_MODULES),\
 $(if $(filter $(module),$(build_modules)),,\
  $(error wifi module "$(module)" has no driver support!)\
 )\
)
endif

#enable clang CFI for arm64
ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_CFI_INCLUDE_PATHS += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/wpa_supplicant_8_lib
PRODUCT_CFI_INCLUDE_PATHS += vendor/amlogic/common/wifi_bt/wifi/wifi_hal/wpa_supplicant_8_lib
endif

PRODUCT_PACKAGES += wpa_supplicant.conf

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml
PRODUCT_PROPERTY_OVERRIDES += \
	ro.carrier=wifi-only

PRODUCT_PACKAGES += \
    wificond \
    wifilogd \
    libwifi-hal-common-ext

MULTI_WIFI_SUPPORT := true
WIFI_DRIVER_MODULE_PATH := /vendor/lib/modules/
WIFI_DRIVER_MODULE_NAME := dhd
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION			:= VER_0_8_X_AML
BOARD_WPA_SUPPLICANT_DRIVER	:= NL80211
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_multi
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_multi
BOARD_HOSTAPD_DRIVER				:= NL80211
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
        frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml
PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0 \
	wifi.direct.interface=p2p0

PRODUCT_PACKAGES += \
    bcmdl \
	wpa_cli

PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/configs/init_rc/init.amlogic.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi.rc

PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/bcm_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/bcm_supplicant.conf
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/bcm_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/bcm_supplicant_overlay.conf

PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

ifneq ($(filter ap6181,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6181/Wi-Fi/fw_bcm40181a2_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6181/Wi-Fi/nvram_ap6181.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/40181/nvram.txt
endif

ifneq ($(filter ap6335,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6335/fw_bcm4339a0_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6335/fw_bcm4339a0_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6335/fw_bcm4339a0_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6335/fw_bcm4339a0_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6335/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6335/nvram_ap6335.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6335/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6335/config.txt
endif

ifneq ($(filter ap6234,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6234/fw_bcm43341b0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6234/fw_bcm43341b0_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6234/fw_bcm43341b0_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6234/fw_bcm43341b0_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6234/fw_bcm43341b0_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6234/fw_bcm43341b0_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6234/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6234/nvram.txt
endif

ifneq ($(filter ap6255,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/fw_bcm43455c0_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/fw_bcm43455c0_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6255/fw_bcm43455c0_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/fw_bcm43455c0_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6255/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/nvram_ap6255.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/config.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6256/Wi-Fi/fw_bcm43456c5_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/fw_bcm43456c5_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6256/Wi-Fi/fw_bcm43456c5_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/fw_bcm43456c5_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6256/Wi-Fi/nvram_ap6256.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6255/nvram_ap6256.txt
endif

ifneq ($(filter ap6271 bcm43751_s,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6271S/Wi-Fi/clm_bcm43751a1_ag.blob:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/AP6271/clm_bcm43751a1_ag.blob
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6271S/Wi-Fi/fw_bcm43751a1_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/AP6271/fw_bcm43751a1_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6271S/Wi-Fi/fw_bcm43751a1_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/AP6271/fw_bcm43751a1_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6271S/Wi-Fi/nvram_ap6271s.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/AP6271/nvram_ap6271s.txt
endif

ifneq ($(filter ap6212,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6212/fw_bcm43438a0.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6212/fw_bcm43438a0.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6212/fw_bcm43438a0_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6212/fw_bcm43438a0_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6212/fw_bcm43438a0_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6212/fw_bcm43438a0_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/6212/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6212/nvram.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/6212/config.txt
endif

ifneq ($(filter ap6354,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4354/fw_bcm4354a1_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4354/fw_bcm4354a1_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4354/fw_bcm4354a1_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4354/fw_bcm4354a1_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4354/nvram_ap6354.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4354/nvram_ap6354.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4354/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4354/config.txt
endif

ifneq ($(filter ap6356,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4356/fw_bcm4356a2_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4356/fw_bcm4356a2_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4356/fw_bcm4356a2_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4356/fw_bcm4356a2_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4356/nvram_ap6356.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4356/nvram_ap6356.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4356/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4356/config.txt
endif

ifneq ($(filter ap6398s,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6398/Wi-Fi/fw_bcm4359c0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4359/fw_bcm4359c0_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6398/Wi-Fi/fw_bcm4359c0_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4359/fw_bcm4359c0_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6398/Wi-Fi/fw_bcm4359c0_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4359/fw_bcm4359c0_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6398/Wi-Fi/nvram_ap6398s.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4359/nvram_ap6398s.txt
endif

ifneq ($(filter ap6275s,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275/Wi-Fi/fw_bcm43752a2_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm43752a2_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275/Wi-Fi/fw_bcm43752a2_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm43752a2_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275/Wi-Fi/fw_bcm43752a2_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm43752a2_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275/Wi-Fi/clm_bcm43752a2_ag.blob:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/clm_bcm43752a2_ag.blob
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275/Wi-Fi/nvram_ap6275s.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/nvram_ap6275s.txt
endif

ifneq ($(filter bcm43458_s,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43458/fw_bcm43455c0_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43458/fw_bcm43455c0_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/43458/fw_bcm43455c0_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43458/fw_bcm43455c0_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/43458/nvram_43458.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43458/nvram_43458.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/43458/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43458/config.txt
endif

ifneq ($(filter bcm4358_s,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4358/fw_bcm4358_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4358/fw_bcm4358_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4358/fw_bcm4358_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4358/fw_bcm4358_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4358/fw_bcm4358_ag_p2p.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4358/fw_bcm4358_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4358/nvram_4358.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4358/nvram_4358.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/4358/config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/4358/config.txt
endif

ifneq ($(filter ap6269 ap62x8,$(WIFI_MODULES)),)
ifeq ($(CONFIG_BCMDHD_CUSB),y)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/nvram_ap62x8.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/nvram_ap62x8.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm43569a2_ag.bin.trx
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/USB_COMPOSITE/nvram_ap62x8.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/nvram_ap6269a2.nvm
else
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag_p2p.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm4358u_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/nvram_ap62x8.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/nvram_ap62x8.txt
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/fw_bcm4358u_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/fw_bcm43569a2_ag.bin.trx
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP62x8/nvram_ap62x8.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43569/nvram_ap6269a2.nvm
endif
endif

ifneq ($(filter ap6275p,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275p/Wi-Fi/fw_bcm43752a2_pcie_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm43752a2_pcie_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275p/Wi-Fi/fw_bcm43752a2_pcie_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm43752a2_pcie_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275p/Wi-Fi/clm_bcm43752a2_pcie_ag.blob:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/clm_bcm43752a2_pcie_ag.blob
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275p/Wi-Fi/nvram_ap6275p.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/nvram_ap6275p.txt
endif

ifneq ($(filter ap6275hh3,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275hh3/Wi-Fi/fw_bcm4375b4_pcie_ag.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm4375b4_pcie_ag.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275hh3/Wi-Fi/fw_bcm4375b4_pcie_ag_apsta.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/fw_bcm4375b4_pcie_ag_apsta.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275hh3/Wi-Fi/clm_bcm4375b4_pcie_ag.blob:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/clm_bcm4375b4_pcie_ag.blob
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/bcm_ampak/config/AP6275hh3/Wi-Fi/nvram_ap6275hh3.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/43752a2/nvram_ap6275hh3.txt
endif

ifneq ($(filter qca6174,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/bdwlan30.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/bdwlan30.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/athwlan.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/athwlan.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/otp30.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/otp30.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/utf30.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/utf30.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/qwlan30.bin:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/qwlan30.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/wlan/cfg.dat:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/wlan/cfg.dat
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/qcom/config/qca6174/wifi/wlan/qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6174/wlan/qcom_cfg.ini
endif

ifneq ($(filter w1,$(WIFI_MODULES)),)
ifeq (,$(wildcard vendor/wifi_driver/amlogic/w1/wifi/project_w1/vmac))
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*.txt,vendor/amlogic/common/wifi_bt/wifi/w1,$(TARGET_COPY_OUT_VENDOR)/etc/wifi/w1/)
else
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*.txt,vendor/wifi_driver/amlogic/w1/wifi/project_w1/vmac,$(TARGET_COPY_OUT_VENDOR)/etc/wifi/w1/)
endif
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/w1/iwpriv:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/w1/iwpriv
WIFI_HIDL_FEATURE_DUAL_INTERFACE := false
endif

ifneq ($(filter sd8987,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/nxp/firmware/sd8987/sd8987_wlan.bin:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/nxp/sd8987_wlan.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/nxp/firmware/sd8987/WlanCalData_ext.conf:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/nxp/WlanCalData_ext.conf
PRODUCT_PACKAGES += mfgbridge mlanutl
endif

ifneq ($(filter uwe5621ds,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/unisoc/uwe5621/config/wifi/wifi_56630001_3ant.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi_56630001_3ant.ini
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/unisoc/uwe5621/config/bt/bt_configure_pskey.ini:$(TARGET_COPY_OUT_VENDOR)/etc/bt_configure_pskey.ini
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/unisoc/uwe5621/config/bt/bt_configure_rf.ini:$(TARGET_COPY_OUT_VENDOR)/etc/bt_configure_rf.ini
endif

ifneq ($(filter mt7663u mt7668u mt7661,$(WIFI_MODULES)),)
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/EEPROM_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7668.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/EEPROM_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EEPROM_MT7663.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/mt7668_patch_e1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt7668_patch_e1_hdr.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/TxPwrLimit_MT76x8.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/TxPwrLimit_MT76x8.dat
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/wifi.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi.cfg
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/WIFI_RAM_CODE2_USB_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE2_USB_MT7668.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/WIFI_RAM_CODE2_SDIO_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE2_SDIO_MT7668.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/WIFI_RAM_CODE_MT7668.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_MT7668.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/mt7668_patch_e2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt7668_patch_e2_hdr.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/WIFI_RAM_CODE_MT7663.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_MT7663.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/mt7663_patch_e2_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/mt7663_patch_e2_hdr.bin
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/7668_firmware/wifi_mt7661.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/wifi_mt7661.cfg
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/mediatek/RT2870STA_7601.dat:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/RT2870STA_7603.dat
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/mediatek/dhcpcd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/dhcpcd/dhcpcd.conf
PRODUCT_COPY_FILES += vendor/amlogic/common/wifi_bt/wifi/multi_wifi/config/mediatek/MT7601USTA.dat:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/MT7601USTA.dat
endif

