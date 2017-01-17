# Depricated For Replacement C++ Project
I have depricated this project as it was meant to be an example.  I am currently developing my new project in C++ and will have a release ready soon.  It's name is GPUMAGIC and it is specifically engineered not just for mining but for managing any large compute cluster which uses **AMD** Graphics Cards.  You can get more information on it in my repository GPUMAGIC which is also the future home of the code (currently in testing and debugging)

# amdgpu-pro-fans

Author: DominiLux
License: Apache Version 2.0

This is an alpha release written in unix style bash script.  It is a simple utility that allows you to set the fan speeds for AMD cards that support use the AMD GPU PRO driver.  There are many features I will be adding to this over the coming days and weeks.

## Stable Branch
The current master branch is considered the stable release.  The code in the development branch may not have been fully tested.

## Installation Instructions:
* sudo apt-get install git
* git clone https://github.com/dominilux/amdgpu-pro-fans
* cd amdgpu-pro-fans
* chmod +x amdgpu-pro-fans.sh

## Usage:
sudo ./amdgpu-pro-fans.sh -s [speed 0 - 100]

## Usage Example:
sudo ./amdgpu-pro-fans.sh s 80
That would set all of your fan speeds to 80 percent of their maximum speed.  The argument works perfectly as of the current stable release.

## Notes:
Fully tested on Ubuntu 16.04 with AMDGPU-PRO proprietary linux drivers.  It is now compatible with all Radeon R8 Series, R9 Series, and RX Series graphics cards.  I will be adding the option to specify a specific adapter soon.  It will be in the works in the development branch and I will merge it here once it's coded, tested, and debugged.

This version defaults to all adapters.
