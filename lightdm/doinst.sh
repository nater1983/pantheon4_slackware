# creating lightdm group if he isn't already there
if ! getent group lightdm >/dev/null; then
        addgroup --system lightdm
fi

# creating lightdm user if he isn't already there
if ! getent passwd lightdm >/dev/null; then
        adduser --system --ingroup lightdm --home /var/lib/lightdm lightdm
        usermod -c "Light Display Manager" lightdm
        usermod -d "/var/lib/lightdm"      lightdm
        usermod -g "lightdm"               lightdm
        usermod -s "/bin/false"            lightdm
fi
