# Pantheon For Slackware 

This project is based on 

[Pantheon DE](https://github.com/elementary)<br>
_designed and developed for elementary OS_<br><br>
[GFS Project]([https://github.com/slackport/gfs](https://reddoglinux.ddns.net/linux/gnome))<br>
_Gnome 4x.x for Slackware_<br><br>
[SlackBuilds Team](https://slackbuilds.org/)<br>
_A community-driven repository for Slackware users_<br><br>
[Slackware 15](http://www.slackware.com/announce/15.0.php)<br>
_The Slackware Linux Project_<br><br><br>

<h2>Configuration</h2>

1. We need to add some groups and users for our Pantheon DE:

```
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
```

**2. Avahi need to be run at boot, so edit your /etc/rc.d/rc.local adding these lines:**

```
# Start avahidaemon
if [ -x /etc/rc.d/rc.avahidaemon ]; then
 /etc/rc.d/rc.avahidaemon start
fi
# Start avahidnsconfd
if [ -x /etc/rc.d/rc.avahidnsconfd ]; then
  /etc/rc.d/rc.avahidnsconfd start
fi
```

**4. Also stop Avahi at shutdown, so edit your /etc/rc.d/rc.local_shutdown adding these lines:**

```
# Stop avahidnsconfd
if [ -x /etc/rc.d/rc.avahidnsconfd ]; then
  /etc/rc.d/rc.avahidnsconfd stop
fi
# Stop avahidaemon
if [ -x /etc/rc.d/rc.avahidaemon ]; then
  /etc/rc.d/rc.avahidaemon stop
fi
```

**5. We also need to mark our new created /etc/rc.d/rc.local_shutdown file as executable**

`chmod +x /etc/rc.d/rc.local_shutdown`

**6. Edit your /etc/inittab to go 4 runlevel**

from:
`id:3:initdefault:`
to
`id:4:initdefault:`

**7. Add lightdm and make sure lightdm is the first one to run in the /etc/rc.d/rc.4**

```
# to use lightdm  by default:
if [ -x /usr/bin/lightdm ]; then
  exec /usr/bin/lightdm
fi
```
**8. Edit your /etc/lightdm/lightdm.conf file to use Pantheon greeter by default.**

In the `[Seat:*]` section uncomment and change<br>
<br>`#greeter-session=example-gtk-gnome`<br>to<br>`greeter-session=io.elementary.greeter`<br><br>

<h2>Screenshot</h2>
![Screenshot_from_2021-12-20_06-08-57](/uploads/99eb60c4f2595ddcac9d69bc3ca407b1/Screenshot_from_2021-12-20_06-08-57.png)

<h2>Thanks</h2>
[ElementaryOS Team](https://github.com/elementary)<br>
[GFS Project](https://github.com/slackport/gfs)<br>
[SlackBuilds Team](https://slackbuilds.org/)
