# amdgpu-pro-fans

Author: DominiLux
License: Apache Version 2.0

This is an alpha release written in unix style bash script.  It is a simple utility that allows you to set the fan speeds for AMD cards that support use the AMD GPU PRO driver.  There are many features I will be adding to this over the coming days and weeks as I use bash script to experiment with direct manipulation of the hardware.

This is the first phase in a multi phase project to attempt to create an aticonfig/fglrx emulator so that existing applications using old SDK's will still have an interface to connect to the cards for hardware monitoring.  I look forward to developing this for the open sourced community.  The version uploaded right now only sets the fan speeds.  Everything else I already know how to to do.  However, I have to find the time to code it first.

Installation Instructions:
sudo apt-get install git
sudo apt-get clone https://github.com/dominilux/amdgpu-pro-fans
cd amdgpu-pro-fans
chmod +x amdgpu-pro-fans.sh

Usage:
sudo ./amdgpu-pro-fans.sh --speed=(0 - 100)

Notes:
This version defaults to all adapters.  The next flag I will be adding will be the --adapter flag to allow a user to specify any specific number of adapters or all adapters.  I also plan on adding a get temperature feature to it as well.  This is Revision 0.1.0 so it's likely to throw some random errors and things as I have not debugged it much.  I will be moving through the revisions of this project very quickly to have the concepts laid out for the c++ application I mentioned earlier.
