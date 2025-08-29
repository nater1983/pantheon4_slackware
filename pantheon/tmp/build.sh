#!/bin/bash
PSB=/var/cache/psb

if [ ! -d ${PSB} ]; then
	mkdir -p $PSB
fi

src=(
	wingpanel-indicator-network 
	indicator-application 
	lightdm 
	lightdm-pantheon-greeter
	xdg-desktop-portal-pantheon
)

for i in ${src[@]}; do
	cd ${i} || exit 1
	sh ${i}.SlackBuild || exit 1
	cd ..
done

exit 0


