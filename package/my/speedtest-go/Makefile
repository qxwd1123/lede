# SPDX-Identifier-License: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest-go
PKG_VERSION:=1.1.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/librespeed/speedtest-go/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=8d2b222571e93f97a08a15f5bf415ab921ede7390df416e03deeb14fb3735b9c

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=a <a@a>

PKG_CONFIG_DEPENDS:= \
	CONFIG_SPEEDTEST_GO_COMPRESS_GOPROXY \
	CONFIG_SPEEDTEST_GO_COMPRESS_UPX

#PKG_BUILD_DIR:=$(BUILD_DIR)/$(firstword $(subst -, ,$(PKG_NAME)))-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/librespeed/speedtest-go
GO_PKG_BUILD_PKG:=github.com/librespeed/speedtest
GO_PKG_LDFLAGS:=-s -w
COMPILE_TIME:= $(shell TZ=UTC-8 date '+%Y-%m-%d %H:%M:%S')
GO_PKG_LDFLAGS_X+= \
	$(GO_PKG).version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/speedtest-go/config
config SPEEDTEST_GO_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config SPEEDTEST_GO_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default y
endef

ifeq ($(CONFIG_SPEEDTEST_GO_COMPRESS_GOPROXY),y)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.io
endif

define Package/speedtest-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Librespeed (Golang)
  URL:=https://github.com/librespeed/speedtest-go
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_GOST_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/speedtest
endif
endef

define Package/speedtest-go/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/librespeed
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/speedtest $(1)/usr/bin/librespeed/speedtest
	$(INSTALL_DIR) $(1)/usr/bin/librespeed/assets
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./file/root/etc/init.d/speedtest-go $(1)/etc/init.d/speedtest-go
	$(CP) $(PKG_BUILD_DIR)/assets/* $(1)/usr/bin/librespeed/assets/
	sed -i $(PKG_BUILD_DIR)/settings.toml
	$(CP) $(PKG_BUILD_DIR)/settings.toml $(1)/usr/bin/librespeed/
endef

$(eval $(call GoBinPackage,speedtest-go))
$(eval $(call BuildPackage,speedtest-go))
