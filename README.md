# build-lool

Script collection to build libreoffice online on ubuntu 16.04. Updates
the system, installs and sets up the required packages. Finally builds
libreoffice and libreoffice online.

## Requirements

A minimal or standard installation of Ubuntu 16.04 as VM or on real
Hardware is required. For flawless building, the following system resources
are recommended:

* Disk space: >= 32 GByte
* Memory: >= 4 GByte
* Number of CPU cores: >= 4

Additionally you need an user account with sudo capability.

## Configuration

Before you start please customize the configuration.
Copy config/lool-config.sh.example to config/lool-config.sh.
Adjust config/lool-config.sh to your needs.

You may define different versions for poco, libreoffice core and
libreoffice online. The following software package combinations are
tested and known to work:

Package            | version
-------------------|---------------------
poco               | 1.7.7
libreoffice core   | cp-5.1.17
libreoffice online | 2.0.2-3


Package            | version
-------------------|---------------------
poco               | 1.7.8
libreoffice core   | cp-5.1.18
libreoffice online | 2.0.3

Package            | version
-------------------|---------------------
poco               | 1.7.8
libreoffice core   | cp-5.1.21
libreoffice online | 2.0.4

Package            | version
-------------------|---------------------
poco               | 1.7.8
libreoffice core   | libreoffice-5.3.1.1
libreoffice online | libreoffice-5.3.1.2

It's recommended to leave LOOL_PREFIX as "/opt/lool" and POCO_PREFIX empty.

## Building

As mentioned above. You need a minimal or standard installation of Ubuntu 16.04.
Transfer the build-lool tar archive your build system. Unpack the archive to a
suitable location, ~/tools/ for example. Adjust the configuration to your needs
as described above. Start the shell script build-lool.sh. The script acts as follows:

* Append a line to .bashrc to startup the script at login.
* Enable the corresponding source package repositories for all enabled package repositories.
* Update the system software packages.
* Install all required software packages.
* Reboot system.

After login again:

* Remove the script start command from .bashrc.
* Get the source packages.
* Build poco.
* Build libreoffice core.
* Build libreoffice online.
* Build installable package.

After the script has finished you find the built packages in the subdirectory
"packages".
There are packages for poco, libreoffice core, loolwsd and loleaflet. Depending
on the configuration you will find poco-1.7.7.tar.xz, core-cp-5.1-17.tar.xz,
loolwsd-2.0.2-3.tar.xz, loleaflet-2.0.2-3.tar.gz and a combined package
lool-poco-1.7.7-core-cp-5.1-17-online-2.0.2-3.tar.xz to be installed to "/opt/lool".

If you change source versions after a first build, only the necessary
components are rebuild.

## Installation

You may install the packages manually, or use the script collection install-cloud-server,
see https://github.com/RainerEmrich/install-cloud-server.
