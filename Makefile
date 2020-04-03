#
# Multi-User Application for LuCi
# Added new functions for compatibility for 18.06.1 
# Hostle 2/7/2019 hostle19@gmail.com
#
# Adapted original code for compatibility for 19.07.2
# PrivacyRick 4/3/2020 rick@binaryaeon.com

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCi Multi User Support
LUCI_DEPENDS:=+luci-mod-admin-full

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
