#!/bin/bash

#WMiller, 2/25/2017
#The purpose of this script is to essentially parse the command line arguments for running QEMU with Panda.
#x86/x86_64 only, see the ARM version to run ARM machines.

#Takes either one or no arguments. If an argument is provided, then this script will create a .sh file with the full command to replay a Panda recording. The .sh file will be named exactly what is provided; eg, if you were planning on making a recording named "test1", then you would execute the script as "./qemu_panda_start_x86_64 test1". This serves two purposes, one is to log which arguments were used to create the recording (ram, hard disk, etc) and the other is to make execution simpler.


#Fill the following variables out with the relevant values:


#path to Panda-provided QEMU (no quotes with ~/)
RUNPATH=~/panda/x86_64-softmmu/qemu-system-x86_64

#path to provided hard drive image (img, qcow, etc, if there isn't one, leave blank)
HDA="lubuntu.img"

#boot order. Lowercase "c" for hard drive, lowercase "d" for cd-rom
BOOTTYPE="c"

#memory (ram) in MB (note, make sure to run the replay with the same amount of ram as it was captured with!)
RAM="4096"

#kvm: to run with kvm, "enable-kvm", else leave blank
#Note, currently it doesn't look like Panda's replays work with kvm

KVM=""

#monitor stdio: if running with -nographic, leave blank, otherwise "monitor stdio"
STDIO="monitor stdio"

#command (do not edit)
COMMAND=""

################################################################################

#First, make sure filename for potential output is not already taken
if [ $1 ]; then
   if [ -e $1.sh ]; then
      echo "Output file name already taken, please choose another!"
      exit 0
   fi
fi


COMMAND+=$RUNPATH
if [ $HDA ]; then
   COMMAND+=" -hda $HDA"
fi
COMMAND+=" -boot $BOOTTYPE"
COMMAND+=" -m $RAM"
if [ $KVM ]; then
   COMMAND+=" -$KVM"
fi
if [ "$STDIO" ]; then
   COMMAND+=" -$STDIO"
fi

$COMMAND

#Create an output .sh file to execute recording if there's an extra argument on the command line
if [ $1 ]; then
	COMMANDREPLAY=$COMMAND
	COMMANDREPLAY+=" -replay $1"
	echo $COMMANDREPLAY > $1.sh
fi
