#!/bin/bash
PSB=/var/cache/psb

if [ ! -d ${PSB} ]; then
	mkdir -p $PSB
fi

src=(
	pantheon-tweaks 
	switchboard-plug-network
        librest
	elementary-photos 
	bash-completion 
	wingpanel-indicator-power 
	switchboard-plug-power 
	switchboard-plug-notifications 
	wingpanel-indicator-notifications 
	switchboard-plug-display 
	gtkspell3
	gtksourceview4
	libpeas 
	elementary-code
	folks 
	elementary-mail 
	switchboard-plug-onlineaccounts 
	pantheon-default-settings 
	pantheon-screenshot
	bubblewrap
	libostree
	flatpak
	pantheon-sideload
	cogl
	clutter
	clutter-gst 
	pantheon-videos 
	switchboard-plug-applications 
	ayatana-ido 
	libayatana-indicator 
	libgdiplus 
	mono 
	gtk-sharp 
	perl-xml-libxml 
	libayatana-appindicator 
	ayatana-indicator-application 
	wingpanel-indicator-ayatana 
	switchboard-plug-about 
	switchboard-plug-locale 
	switchboard-plug-useraccounts 
	switchboard-plug-security-privacy 
	switchboard-plug-a11y 
	switchboard-plug-mouse-touchpad 
	pantheon-settings-daemon 
	libgda 
	elementary-music 
	switchboard-plug-printers
	libadwaita 
	pantheon-onboarding
	libchamplain
	gnome-online-accounts
	libgdata 
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
	lightdm-pantheon-greeter
	xdg-desktop-portal-pantheon
)

for i in ${src[@]}; do
	cd ${i} || exit 1
	sh ${i}.SlackBuild || exit 1
	cd ..
done

exit 0


