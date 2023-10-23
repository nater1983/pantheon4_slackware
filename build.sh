#!/bin/bash
PSB=/var/cache/psb

if [ ! -d ${PSB} ]; then
	mkdir -p $PSB
fi

src=(
	libchamplain
	elementary-tasks 
	switchboard-plug-wacom 
	switchboard-plug-sharing 
	switchboard-plug-bluetooth 
	elementary-camera 
	elementary-calendar 
	wingpanel-indicator-nightlight 
	elementary-contractor 
	elementary-print 
	elementary-fonts 
	wingpanel-indicator-network 
	indicator-application 
	lightdm 
	lightdm-gtk-greeter 
	lightdm-pantheon-greeter
)

for i in ${src[@]}; do
	cd ${i} || exit 1
	sh ${i}.SlackBuild || exit 1
	cd ..
done

exit 0


