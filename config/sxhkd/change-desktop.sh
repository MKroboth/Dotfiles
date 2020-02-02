DESKTOP_ID="$1"
DESKTOPS=$(bspc query -M)
shift
for desktop in $DESKTOPS; do
	$@ $(bspc query -m $desktop -D | sed -n ${DESKTOP_ID}p)
done
