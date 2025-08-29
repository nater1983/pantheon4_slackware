groupadd -g 214 avahi
useradd -u 214 -g 214 -c "Avahi User" -d /dev/null -s /bin/false avahi
groupadd -g 303 colord
useradd -d /var/lib/colord -u 303 -g colord -s /bin/false colord
groupadd -g 363 sanlock
useradd -u 363 -d /var/run/sanlock -s /bin/false -g sanlock sanlock
usermod -a -G disk sanlock
groupadd -g 319 rabbitmq
useradd -u 319 -g 319 -c "Rabbit MQ" -d /var/lib/rabbitmq -s /bin/sh rabbitmq
groupadd -g 365 lightdm
useradd  -c "Lightdm Daemon" -d /var/lib/lightdm -u 365 -g lightdm -s /bin/false lightdm
