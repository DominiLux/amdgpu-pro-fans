#!/usr/bin/env bash
#####################################
#  AMDGPU-PRO LINUX UTILITIES SUITE  #
######################################
# Utility Name: AMDGPU-PRO-FANS
# Version: 0.1.5
# Version Name: MahiMahi
# https://github.com/DominiLux/amdgpu-pro-fans

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#####################################################################
#                          *** IMPORTANT ***                        #
# DO NOT MODIFY PAST THIS POINT IF YOU DONT KNOW WHAT YOUR DOING!!! # 
#####################################################################

############################
# COMMAND PARSED VARIABLES #
############################
adapter="all"
targettemp=""
fanpercent=""
arguments="$@"
##################
# USAGE FUNCTION #
##################
usage ()
{
    echo "* AMDGPU-PRO-FANS *"
    echo "error: invalid arguments"
    echo "usage: $0 [-h] for help..."
    exit
}

###########################
# SET FAN SPEED FUNCTIONS #
###########################

set_all_fan_speeds ()
{
    cardcount="0";
    for CurrentCard in  /sys/class/drm/card?/ ; do
         for CurrentMonitor in "$CurrentCard"device/hwmon/hwmon?/ ; do
              cd $CurrentMonitor # &>/dev/null
              workingdir="`pwd`"
              fanmax=$(head -1 "$workingdir"/pwm1_max)
              if [ $fanmax -gt 0 ] ; then    
                  speed=$(( fanmax * fanpercent ))
                  speed=$(( speed / 100 ))
                  sudo chown $USER "$workingdir"/pwm1_enable
                  sudo chown $USER "$workingdir"/pwm1
                  sudo echo -n "1" >> $workingdir/pwm1_enable # &>/dev/null
                  sudo echo -n "$speed" >> $workingdir/pwm1 # &>/dev/null
                  speedresults=$(head -1 "$workingdir"/pwm1)
                  if [ $(( speedresults - speed )) -gt 6 ] ; then
                       echo "Error Setting Speed For Card$cardcount!"
                  else
                       echo "Card$cardcount Speed Set To $fanpercent %"
                  fi
              else
                  echo "Error: Unable To Determine Maximum Fan Speed For Card$cardcount!"
              fi
         done
         cardcount="$(($cardcount + 1))"
    done
}

set_fans_requested ()
{
    if [ "$adapter"="all" ] ; then
        set_all_fan_speeds
    fi
}


#################################
# PARSE COMMAND LINE PARAMETERS #
#################################
command_line_parser ()
{
     parseline=`getopt -s bash -u -o a:s: -n '$0' -- "$arguments"` 
     eval set -- "$parseline"
     while true ; do
        case "$1" in
            -a ) adapter="$2" ; shift 2 ;;
            -s ) fanpercent="$2" ; set_fans_requested ; break ;;
            --)  break ;;
            *) usage ; exit 1 ;;
        esac    
    done
}

#################
# Home Function #
#################

command_line_parser
exit;
