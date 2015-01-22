#!/bin/bash
#### Reminder how to add missing mode
# xrandr --newmode "1080p" 172.63  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
# xrandr --addmode eDP1 1080p    

#### Configuration

EDP_OUTPUT="--output eDP1 --mode 1080p "

# Virtual dislay
VIRTUAL1_OFF="--output VIRTUAL1 --off "

# xrandr --output HDMI1 --off --output VIRTUAL1 --off --output eDP1 --mode 1080p --pos 0x0 --rotate normal --output VGA1 --off

# HDMI
HDMI_ON="--output HDMI1 --mode 1920x1080 --rotate normal "
HDMI_OFF="--output HDMI1 --off "

# VGA
VGA_ON="--output VGA1 --mode 1920x1080 --rotate normal "
VGA_OFF="--output VGA1 --off "



RIGHT_POSITION="--right-of eDP1 "
LEFT_POSITION="--left-of eDP1 "


#### Script

#Detect the name of the external screen(s) connected
# display all infos | get only connected string | get the name of the display (first element) | remove the eDP1 line
SCREEN_CONNECTED=( $(xrandr | grep " connected" | awk '{print $1}' | grep eDP1 -v) )

# echo ${SCREEN_CONNECTED[@]}

# echo the previous variable | remove blank line | count the lines
NUMBER_CONNECTED_SCREEN=$(echo $SCREEN_CONNECTED |sed '/^\s*$/d' | wc -l)

echo $NUMBER_CONNECTED_SCREEN "external screen(s)"

# return y if the element is in the array
# example $(contains "${ARRAY[@]}" "VGA1") == "y"
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}



XRANDR_COMMAND="xrandr "$EDP_OUTPUT$VIRTUAL1_OFF


if [ $(contains "${SCREEN_CONNECTED[@]}" "VGA1") == "y" ]; then
# VGA connected 
	echo "VGA on"
	XRANDR_COMMAND+=$VGA_ON$RIGHT_POSITION
else
	echo "VGA off"
	XRANDR_COMMAND+=$VGA_OFF
fi


if [ $(contains "${SCREEN_CONNECTED[@]}" "HDMI1") == "y" ]; then
# HDMI connected 
	echo "HDMI on"
	XRANDR_COMMAND+=$HDMI_ON$LEFT_POSITION
else
	echo "HDMI off"
	XRANDR_COMMAND+=$HDMI_OFF
fi

echo $XRANDR_COMMAND
$XRANDR_COMMAND

echo "Restart conky"
kill $(pidof conky)
conky  -q -c $HOME/.conky/conkyrc_seamod &

echo "Restore nitrogen"
$(nitrogen --restore)

echo "end"