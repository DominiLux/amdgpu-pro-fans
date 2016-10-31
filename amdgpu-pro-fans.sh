#/bin/bash
######################################
#  AMDGPU-PRO LINUX UTILITIES SUITE  #
######################################
# Utility Name: AMDGPU-PRO-FANS
# Version: 0.1.1
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

# Set the percentage you want your fans to run at below.  I'll add the iteration for a --fan-speed flag soon.

fanpercent="75";



#####################################################################
#                          *** IMPORTANT ***                        #
# DO NOT MODIFY PAST THIS POINT IF YOU DONT KNOW WHAT YOUR DOING!!! # 
#####################################################################

## DEFAULT VARIABLES ##
error="";
success="";
verbosity="2";
returndata="";

# Constants #

###############################
# SET ALL FAN SPEEDS THE SAME #
###############################

gracefull_close () 
{
    #clear
    if [ "$verbosity" = "2" ] ; then
        # Print A Nice Closing Message
        stty echo;
           # TO DO: ADD THE FRIENDLY MESSAGE
        stty -echo;
    elif [ "$verbosity" = "1" ] ; then
        # Just print the data
        stty echo;
           # TO DO: ADD THE DATA ONLY MESSAGE
        stty -echo;
    elif [ "$verbosity" = "0" ] ; then
        # Dont print anything
        stty echo;
        stty -echo;
    else
        stty echo;
        # Print A Message Reminding The User To Set The Verbosity correctly
        # just in case it gets past initial flags error checking
        echo "You used an invalid -v (--verbosity) flag";
        echo "Correct values are 0, 1, or 2 [Default: 2]";
        echo "Please run the program with -h or --help flag for help";
        echo "Application will now exit but will not report any data without the flag set";
        stty -echo;
    fi
    stty echo;
    exit;
}

gracefull_success ()
{
    #lear
    if [ "$verbosity" = "2" ] ; then
        # Print A Nice Error Message
        stty echo;
        echo "";
        echo "****************************";
        echo "* Request Returned Success *";
        echo "****************************";
        echo "";
        echo "$success";
        stty -echo;
    elif [ "$verbosity" = "1" ] ; then
        # Just Print The Word Success 
        stty echo;
        echo "SUCCESS";
        stty -echo;
    elif [ "$verbosity" = "0" ] ; then
        # Dont Print Anything
        stty echo;
        stty -echo;
    else
        # Print A Message Reminding The User To Set The Verbosity correctly
        # just in case it gets past initial flags error checking
        stty echo;
        echo "";
        echo "You used an invalid -v (--verbosity) flag";
        echo "Correct values are 0, 1, or 2 [Default: 2]";
        echo "Please run the program with -h or --help flag for help";
        echo "Application will now exit but will not report any data without the flag set";
        echo "";
        stty -echo;
    fi
}

gracefull_error ()
{
   # clear
    stty echo;
    if [ "$verbosity" = "2" ] ; then
        # Print A Nice Error Message
        stty echo;
        echo "";
        echo "***************************";
        echo "* Request Returned Errors *";
        echo "***************************";
        echo "";
        echo $error;
        stty -echo;
    elif [ "$verbosity" = "1" ] ; then
        # Just Print The Word Error
        stty echo;
        echo "ERROR";
        stty -echo;
    elif [ "$verbosity" = "0" ] ; then
        # Dont Print Anything
        stty echo;
        stty -echo;
    else
        # Print A Message Reminding The User To Set The Verbosity correctly
        # just in case it gets past initial flags error checking
        stty echo;
        echo "";
        echo "You used an invalid -v (--verbosity) flag";
        echo "Correct values are 0, 1, or 2 [Default: 2]";
        echo "Please run the program with -h or --help flag for help";
        echo "Application will now exit but will not report any data without the flag set";
        echo "";
        stty -echo;
    fi
}

set_all_fan_speeds ()
{
    cardcount="0";
    for i in  /sys/class/drm/card?/ ; do
         if cd "$i"device/hwmon/hwmon* ; then
             cd /sys/class/drm/card$cardcount/device/hwmon/hwmon*
             workingdir="`pwd`";
             fanmax="255"
            # fanmax=$(<$workingdir/pwm1_max);
             if [ "$fanmax" != "0" ] ; then
            # fanmax=cat pwm1_max ;
             speed=$(( fanmax / 100 ));
             speed=$(( speed * fanpercent ));
                 if sudo echo "$speed" > $workingdir/pwm1 ; then
                     success="$success SUCCESS: Fan Speed Set To $fanpercent % for Card$cardcount \n    $workingdir/pwm1\n";
                 else
                     error="$error ERROR: could not set fan speed for Card$cardcount\n";
                 fi
             else
                 error="$error ERROR: Could not get max fan speed for: Card$cardcount\n";
             fi
         else
             error="$error ERROR: Could not locate device Card$cardcount\n";
         fi
         cardcount="$(($cardcount + 1))"; 
    done
}

#################
# Home Function #
#################

# This utility requires itself to elevate to the root user.
echo "Checking for elivated privlidges . . ."
if [[ $(id -u) -ne 0 ]] ; then
    # We are not the root user yet.  
    echo "You did not run as the utility with 'sudo'!"
    echo "You will be prompted for your sudo password before any changes can be made."
fi
set_all_fan_speeds
if [ "$error" != "" ] ; then
# Print The Error Messages
    gracefull_error
elif [ "$success" != "" ] ; then
# Print The Success Messages
    gracefull_success
else
    echo "What the hell happened!!!";
fi
stty echo;
gracefull_close
exit;
