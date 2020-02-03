#!/bin/sh
BATTERY_FULL_CHARGING=""
BATTERY_CAP=" "

BATTERY_EMPTY=""
BATTERY_HALF_FULL=""
BATTERY_FULL=""

UPS_CHARGE=$(upsc powerwalker@localhost | awk -F: '/battery\.charge/ {print $2}')
upsc powerwalker@localhost | awk -F: '/ups.status/ {print $2}' | grep 'CHRG' &>/dev/null
UPS_STATUS_CHARGE=$?

if [ $UPS_CHARGE -gt 98 ]; then
	if [ $UPS_STATUS_CHARGE -eq 0 ]; then
	  BATTERY_SYM=$BATTERY_FULL_CHARGING
	else
	  BATTERY_SYM=$BATTERY_FULL
	fi
elif [ $UPS_CHARGE -gt 49 ]; then
	BATTERY_SYM=$BATTERY_HALF_FULL
else
	BATTERY_SYM=$BATTERY_EMPTY
fi
	
echo "%{u#ffb52a}%{F#554}$BATTERY_SYM$BATTER_CAP%{F-}$UPS_CHARGE%%{u-}"
