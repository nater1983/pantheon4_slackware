# Pantheon For Slackware 

This project is based on 

[Pantheon DE](https://github.com/elementary)<br>
_designed and developed for elementary OS_<br><br>
[GFS Project](https://reddoglinux.ddns.net/linux/gnome)<br>
_Gnome 4x.x for Slackware_<br><br>
[SlackBuilds Team](https://slackbuilds.org/)<br>
_A community-driven repository for Slackware users_<br><br>
[Slackware 15](http://www.slackware.com/announce/15.0.php)<br>
_The Slackware Linux Project_<br><br><br>

<h2>Configuration</h2>

**1. We need to add some groups and users for our Pantheon DE:**

```
groupadd -g 363 sanlock
useradd -u 363 -d /var/run/sanlock -s /bin/false -g sanlock sanlock
usermod -a -G disk sanlock
groupadd -g 319 rabbitmq
useradd -u 319 -g 319 -c "Rabbit MQ" -d /var/lib/rabbitmq -s /bin/sh rabbitmq
groupadd -g 365 lightdm
useradd  -c "Lightdm Daemon" -d /var/lib/lightdm -u 365 -g lightdm -s /bin/false lightdm
```

**2. Edit your /etc/inittab to go 4 runlevel**

from:
`id:3:initdefault:`
to
`id:4:initdefault:`

**3. Add lightdm and make sure lightdm is the first one to run in the /etc/rc.d/rc.4.local**

```
# to use lightdm  by default:
if [ -x /usr/bin/lightdm ]; then
  exec /usr/bin/lightdm
fi
```
**4. Edit your /etc/lightdm/lightdm.conf file to use Pantheon greeter by default.**

In the `[Seat:*]` section uncomment and change<br>
<br>`#greeter-session=example-gtk-gnome`<br>to<br>`greeter-session=io.elementary.greeter`<br><br>

<h2>Thanks</h2>
[ElementaryOS Team](https://github.com/elementary)<br>
[GFS Project](https://reddoglinux.ddns.net/linux/gnome)<br>
[SlackBuilds Team](https://slackbuilds.org/)
