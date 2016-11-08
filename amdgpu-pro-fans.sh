#/bin/bash
######################################
#  AMDGPU-PRO LINUX UTILITIES SUITE  #
######################################
# Utility Name: AMDGPU-PRO-FANS
# Version: 0.1.4
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
adapter=""
targettemp=""
fanpercent=""

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
              cd $CurrentMonitor &>/dev/null
              workingdir="`pwd`"
              fanmax=$(<$workingdir/pwm1_max)
              if !$fanmax ; then
                   echo "Unable to determine maximum fan speed for Card$cardcount!"
              else
                  speed=$(( fanmax / 100 ))
                  speed=$(( speed * fanpercent ))
                  sudo chown $USER $workingdir/pwm1_enable
                  sudo chown $USER $workingdir/pwm1
                  sudo echo 1 >> $workingdir/pwm1_enable &>/dev/null
                  sudo echo "$speed" >> $workingdir/pwm1 &>/dev/null
                  $speedcheck=$(<$workingdir/pwm1)
                  if [ $speed != $speedcheck ] ; then
                       echo "Unable to set fan speed for Card$cardcount!"
                  else
                       echo "Card$cardcount - Speed Set To $fanpercent %"
                  fi
              fi
         done
         cardcount="$(($cardcount + 1))"
    done
}

set_fans_requested ()
{
    # ToDo: Add Functionality For Adapter Variable
    set_all_fan_speeds
}

#################################
# PARSE COMMAND LINE PARAMETERS #
#################################
command_line_parser ()
{
    # ADAPTER VARIABLE LOOP
    while [ $# -gt 0 ]; do
        case "$1" in
            -a)  $adapter="$2"; break;;
        esac
        shift
    done

    # COMMAND SWITCH LOOP
    while [ $# -gt 0 ]; do
        case "$1" in
#           -h)  ToDo: Code Help Function And Enable Flag
#           -l)  ToDo: Code List Adapters Function And Enable Flag
#           -t)  ToDo: Code Read Temperatures Function And Enable Flag
#           -f)  ToDo: Code Display Fan Speeds Function And Enable Flag
            -s)  $fanpercent="$2"; set-fans-command; exit;;
#           -d)  ToDo: Code Dynamic Temperature Controlling And Enable Flag
        esac
        shift
    done
    usage
}

#################
# Home Function #
#################

command_line_parser
exit;
