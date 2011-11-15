$(call PKG_INIT_LIB, 0.2.3)
$(PKG)_LIB_VERSION:=0.2.3
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.bz2
$(PKG)_SOURCE_MD5:=2c974f95b711e5fd07f78fc4ebfcca66
$(PKG)_SITE:=http://$(pkg).geexbox.org/releases/

$(PKG)_BINARY:=$($(PKG)_DIR)/src/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$(pkg).so.$($(PKG)_LIB_VERSION)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

$(PKG)_DEPENDS_ON := ffmpeg

$(PKG)_CONFIGURE_DEFOPTS := n
$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --disable-static
$(PKG)_CONFIGURE_OPTIONS += --disable-debug
$(PKG)_CONFIGURE_OPTIONS += --disable-optimize
$(PKG)_CONFIGURE_OPTIONS += --disable-strip
$(PKG)_CONFIGURE_OPTIONS += --cross-compile
$(PKG)_CONFIGURE_OPTIONS += --prefix="/usr"

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE1) -C $(LIBDLNA_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE1) -C $(LIBDLNA_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdlna* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/include/libdlna \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libdlna.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/share/doc/libdlna

$(pkg)-uninstall:
	$(RM) $(LIBUPNP_DEST_LIB)/libdlna*.so*

$(PKG_FINISH)
