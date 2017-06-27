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

Additionally you need an user account with sudo capability. Building as user
root does not work.

## Configuration

Before you start please customize the configuration.
Copy config/lool-config.sh.example to config/lool-config.sh.
Adjust config/lool-config.sh to your needs.

You may define different versions for poco, libreoffice core and
libreoffice online. The following software package combinations are
tested and known to work:


Package            | version
-------------------|---------------------
poco               | 1.7.8
libreoffice core   | cp-5.1-24
libreoffice online | 2.0.6

Package            | version
-------------------|---------------------
poco               | 1.7.8p2
libreoffice core   | libreoffice-5.3.3.2
libreoffice online | libreoffice-5.3.3.2

Package            | version
-------------------|---------------------
poco               | 1.7.8p2
libreoffice core   | cp-5.3-14
libreoffice online | 2.1.1

Package            | version
-------------------|---------------------
poco               | 1.7.8p2
libreoffice core   | cp-5.3-17
libreoffice online | 2.1.2

Package            | version
-------------------|---------------------
poco               | 1.7.8p3
libreoffice core   | libreoffice-5.3.4.2
libreoffice online | libreoffice-5.3.4.2

It's recommended to leave LOOL_PREFIX as "/opt/lool" and POCO_PREFIX empty.

## Building

As mentioned above. You need a minimal or standard installation of Ubuntu 16.04.
Transfer the build-lool tar archive your build system. Unpack the archive to a
suitable location, ~/tools/ for example. Adjust the configuration to your needs
as described above. Start the shell script build-lool.sh as ordinary user, building
as user root does not work. The script acts as follows:

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

After the script has finished you find the built packages in the subdirectory "packages".
There are packages for poco, libreoffice core, loolwsd and loleaflet. Depending
on the configuration you will find poco-1.7.7.tar.xz, core-cp-5.1-17.tar.xz,
loolwsd-2.0.2-3.tar.xz, loleaflet-2.0.2-3.tar.gz and a combined package
lool-poco-1.7.7-core-cp-5.1-17-online-2.0.2-3.tar.xz to be installed to "/opt/lool".
For the Collabora LibreOffice Online 2.1 versions there's no seperate loleaflet
package.

If you change source versions after a first build, only the necessary
components are rebuild.

The build will take some time depending on your system resources. I did some tests
with a local VM and an 1&amp;1 Cloud Server XXL. My local VM uses 4 cores of an
Intel(R) Xeon(R) E5-1660 v2 CPU, 4 GByte Memory and 32 GByte disk space. The 1&amp;1
Cloud Server XXL uses 4 CPU cores, 8 GByte memory and 160 GByte disk space.

Both, the 1&amp;1 Cloud Server and my VM, take less than 3 hours to install all necessary
software packages and to build poco, libreoffice core and libreoffice online. So, the
actual cost for using the 1&amp;1 Cloud Server XXL is about 0.20 €. The accounting for the
1&amp;1 Cloud Server is carried out based on used minutes. Using an 1&amp;1 Cloud Server
for building libreoffice online may be advantageous especially if you have a very limited
upload bandwidth.


## Installation

You may install the packages manually, or use the script collection install-cloud-server,
see https://github.com/RainerEmrich/install-cloud-server.
