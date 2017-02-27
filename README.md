# build-lool
Script collection to build libreoffice online on ubuntu 16.04.

Updates the system, installs and sets up the required packages.
Finally builds libreoffice and libreoffice online.

Before you start please customize the configuration in
config/lool-config.sh.

You may define different versions for poco, libreoffice core and
libreoffice online. The current settings are tested by me.

It's recommended to leave LOOL_PREFIX as "/opt/lool".

After the script has finished you find the built packages in the
subdirectory "packages". There are packages for poco, libreoffice
core, loolwsd and loleaflet. Depending on the configuration you will
find poco-1.7.7.tar.xz, core-cp-5.1-17.tar.xz, loolwsd-2.0.2-3.tar.xz
and loleaflet-2.0.2-3.tar.gz.

You may use these packages to install libreoffice online in /opt/lool
or you may use the single package for simple installation:
lool-poco-1.7.7-core-cp-5.1-17-online-2.0.2-3.tar.xz
