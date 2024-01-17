# HW-5.2

## Using systemd Containers

**sudo apt install systemd-container**

```jsx
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libnss-mymachines libnss-systemd libpam-systemd libsystemd0 systemd systemd-sysv systemd-timesyncd
Suggested packages:
  libtss2-rc0
The following NEW packages will be installed:
  libnss-mymachines systemd-container
The following packages will be upgraded:
  libnss-systemd libpam-systemd libsystemd0 systemd systemd-sysv systemd-timesyncd
...
```

> *Команда яка встановлює* контейнеризації на основі systemd, такі як **systemd-nspawn**
> 

**sudo apt install debootstrap**

```jsx
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Suggested packages:
  squid-deb-proxy-client debian-archive-keyring arch-test
The following NEW packages will be installed:
  debootstrap
0 upgraded, 1 newly installed, 0 to remove and 41 not upgraded.
...
```

> *Команда дозволяє встановити інструменти які дозволяють створювати базові системи для нових інсталяцій Debian з використанням інструментів ізоляції та створення віртуальних середовищ.*
> 

**sudo debootstrap --arch=arm64 jammy /var/lib/machines/jammy1**

```jsx
I: Retrieving InRelease 
I: Checking Release signature
I: Valid Release signature (key id F6ECB3762474EDA9D21B7022871920D1991BC93C)
I: Retrieving Packages 
I: Validating Packages 
I: Resolving dependencies of required packages...
I: Resolving dependencies of base packages...
I: Checking component main on http://ports.ubuntu.com/ubuntu-ports...
I: Retrieving adduser 3.118ubuntu5
I: Validating adduser 3.118ubuntu5
```

> використовує **debootstrap** для створення базової системи Ubuntu Jammy (або іншої дистрибутиву) з архітектурою arm64
> 

**machinectl list-images**

```jsx
NAME   TYPE      RO USAGE CREATED                     MODIFIED
jammy  directory no   n/a Wed 2024-01-17 19:14:49 UTC n/a
jammy1 directory no   n/a Wed 2024-01-17 20:39:46 UTC n/a

2 images listed.
```

> *Команда виводить список встановлених образів систем, які можна використовувати для створення контейнерів або віртуальних машин за допомогою **machinectl**.*
> 

**sudo systemd-nspawn -D /var/lib/machines/jammy1 --machine jammy**

```jsx
Spawning container jammy on /var/lib/machines/jammy1.
Press ^] three times within 1s to kill container.
root@jammy:~# passwd
```

> *Команда використовує **systemd-nspawn** для запуску контейнера чи віртуальної машини з ім'ям "bullseye1", який вказується параметром **--machine**.*
> 

**passwd**

> *Сетаємо пароль root-у*
> 

**sudo systemd-nspawn -D /var/lib/machines/jammy1/ --machine jammy -b**

```jsx
Spawning container jammy on /var/lib/machines/jammy1.
Press ^] three times within 1s to kill container.
systemd 249.11-0ubuntu3 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS -OPENSSL +ACL +BLKID +CURL +ELFUTILS -FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP -LIBFDISK +PCRE2 -PWQUALITY -P11KIT -QRENCODE +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
Detected virtualization systemd-nspawn.
Detected architecture arm64.

Welcome to Ubuntu 22.04 LTS!

Hostname set to <uhost1>.
Queued start job for default target Graphical Interface.
[  OK  ] Created slice Slice /system/modprobe.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Forward Password Requests to Wall Directory Watch.

...

Ubuntu 22.04 LTS uhost1 console
```

> *Команда використовує **systemd-nspawn** для створення та запуску контейнера або віртуальної машини з ім'ям "jammy". Параметр **-b** вказує на те, що контейнер повинен бути виконаний в фоновому режимі (background).*
> 

**sudo machinectl start jammy && machinectl status jammy**

```jsx
jammy(15e0f7995b9148a1a36ce3b272740dcc)
           Since: Wed 2024-01-17 20:43:55 UTC; 26s ago
          Leader: 15844 (systemd)
         Service: systemd-nspawn; class container
            Root: /var/lib/machines/jammy
           Iface: ve-jammy
              OS: Ubuntu 22.04 LTS
       UID Shift: 459079680
            Unit: systemd-nspawn@jammy.service
                  ├─payload
                  │ ├─init.scope
                  │ │ └─15844 /usr/lib/systemd/systemd
                  │ └─system.slice
                  │   ├─console-getty.service
                  │   │ └─15918 /sbin/agetty -o "-p -- \\u" --noclear --keep-baud console 115200,38400,9600 vt220
                  │   ├─cron.service
                  │   │ └─15911 /usr/sbin/cron -f -P
                  │   ├─dbus.service
                  │   │ └─15912 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation ->
                  │   ├─networkd-dispatcher.service
                  │   │ └─15914 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
                  │   ├─rsyslog.service
                  │   │ └─15915 /usr/sbin/rsyslogd -n -iNONE
                  │   ├─systemd-journald.service
                  │   │ └─15873 /lib/systemd/systemd-journald
                  │   ├─systemd-logind.service
                  │   │ └─15916 /lib/systemd/systemd-logind
                  │   └─systemd-resolved.service
                  │     └─15909 /lib/systemd/systemd-resolved
                  └─supervisor
                    └─15841 systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth -U --s>

Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Host and Network Name Lookups.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Started User Login Management.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Started Dispatcher daemon for systemd-networkd.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Multi-User System.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Graphical Interface.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]:          Starting Record Runlevel Change in UTMP...
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Finished Record Runlevel Change in UTMP.
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]: 
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]: Ubuntu 22.04 LTS uhost1 console
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]:
```

> *Команда використовує **machinectl** для запуску машини (в даному випадку, "bullseye1") та отримання інформації про її поточний стан.*
> 

**systemctl status systemd-nspawn@jammy.service**

```jsx
● systemd-nspawn@jammy.service - Container jammy
     Loaded: loaded (/lib/systemd/system/systemd-nspawn@.service; disabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-01-17 20:43:55 UTC; 40s ago
       Docs: man:systemd-nspawn(1)
   Main PID: 15841 (systemd-nspawn)
     Status: "Container running: Startup finished in 151ms."
      Tasks: 13 (limit: 16384)
     Memory: 21.2M
        CPU: 287ms
     CGroup: /machine.slice/systemd-nspawn@jammy.service
             ├─payload
             │ ├─init.scope
             │ │ └─15844 /usr/lib/systemd/systemd
             │ └─system.slice
             │   ├─console-getty.service
             │   │ └─15918 /sbin/agetty -o "-p -- \\u" --noclear --keep-baud console 115200,38400,9600 vt220
             │   ├─cron.service
             │   │ └─15911 /usr/sbin/cron -f -P
             │   ├─dbus.service
             │   │ └─15912 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --sysl>
             │   ├─networkd-dispatcher.service
             │   │ └─15914 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
             │   ├─rsyslog.service
             │   │ └─15915 /usr/sbin/rsyslogd -n -iNONE
             │   ├─systemd-journald.service
             │   │ └─15873 /lib/systemd/systemd-journald
             │   ├─systemd-logind.service
             │   │ └─15916 /lib/systemd/systemd-logind
             │   └─systemd-resolved.service
             │     └─15909 /lib/systemd/systemd-resolved
             └─supervisor
               └─15841 systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth -U --settin>

Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Host and Network Name Lookups.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Started User Login Management.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Started Dispatcher daemon for systemd-networkd.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Multi-User System.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Graphical Interface.
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]:          Starting Record Runlevel Change in UTMP...
Jan 17 20:43:55 uhost1 systemd-nspawn[15841]: [  OK  ] Finished Record Runlevel Change in UTMP.
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]: 
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]: Ubuntu 22.04 LTS uhost1 console
Jan 17 20:43:56 uhost1 systemd-nspawn[15841]:
```

> *Команда виводить статус служби systemd-nspawn, яка відповідає за контейнер або віртуальну машину.*
> 

**sudo machinectl login jammy**

```jsx
Connected to machine jammy. Press ^] three times within 1s to exit session.

Ubuntu 22.04 LTS uhost1 pts/1

uhost1 login:
```

> *Команда для входу в контейнер або віртуальну машину.*
> 

**sudo machinectl stop jammy**

```jsx
Без output
```

> *Команда для зупинки контейнера або віртуальної машини.*
> 

**systemctl status systemd-nspawn@jammy.service**

```jsx
○ systemd-nspawn@jammy.service - Container jammy
     Loaded: loaded (/lib/systemd/system/systemd-nspawn@.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
       Docs: man:systemd-nspawn(1)

Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: [  OK  ] Stopped Remount Root and Kernel File Systems.
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target System Shutdown.
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target Late Shutdown Services.
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: [  OK  ] Finished System Power Off.
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: [  OK  ] Reached target System Power Off.
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: Sending SIGTERM to remaining processes...
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: Sending SIGKILL to remaining processes...
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: All filesystems, swaps, loop devices, MD devices and DM devices detach>
Jan 17 20:45:07 uhost1 systemd-nspawn[15841]: Powering off.
Jan 17 20:45:07 uhost1 systemd[1]: systemd-nspawn@jammy.service: Deactivated successfully.
```

> *Команда виводить статус служби systemd-nspawn, яка відповідає за контейнер або віртуальну машину.*
> 

**sudo machinectl start jammy**

```jsx
Без output
```

> *Команда запуска контейнер або віртуальну машину.*
> 

**sudo machinectl login jammy**

```jsx
Connected to machine jammy. Press ^] three times within 1s to exit session.

Ubuntu 22.04 LTS uhost1 pts/1

uhost1 login: root
Password: 
Welcome to Ubuntu 22.04 LTS (GNU/Linux 5.15.0-91-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Wed Jan 17 20:33:46 UTC 2024 on pts/1
root@uhost1:~#
```

> *Команда для входу в контейнер або віртуальну машину.*
> 

**sudo systemctl edit --full --force jammy.service**

```jsx
[Unit]
Description=Jammy Container

[Service]
LimitNOFILE=100000
ExecStart=/usr/bin/systemd-nspawn --machine=jammy --directory=/var/lib/machines/jammy1/ -b --network-ipvlan=ens160 --boot
Restart=always

[Install]
Also=dbus.service
WantedBy=default.target
```

> *Команда відкриває або створює конфігураційний файл для сервісу jammy у текстовому редакторі. Параметр **--full** вказує на повний режим редагування, а **--force** дозволяє перезаписати існуючий файл.*
> 

**systemctl cat jammy.service**

```jsx
# /etc/systemd/system/jammy.service
[Unit]
Description=Jammy Container

[Service]
LimitNOFILE=100000
ExecStart=/usr/bin/systemd-nspawn --machine=jammy --directory=/var/lib/machines/jammy1/ -b --network-ipvlan=ens160 --boot
Restart=always

[Install]
Also=dbus.service
WantedBy=default.target
```

> *Команда виводить конфігураційний файл служби.*
> 

**sudo systemctl start jammy.service**

```jsx
Без output
```

> *Команда для запуску служби.*
> 

**sudo systemctl status jammy** 

```jsx
● jammy.service - Jammy Container
     Loaded: loaded (/etc/systemd/system/jammy.service; disabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-01-17 20:47:54 UTC; 5s ago
   Main PID: 16314 (systemd-nspawn)
      Tasks: 1 (limit: 4524)
     Memory: 1.1M
        CPU: 11ms
     CGroup: /system.slice/jammy.service
             └─16314 /usr/bin/systemd-nspawn --machine=jammy --directory=/var/lib/machines/jammy1/ -b --network-ipv>

Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Started User Login Management.
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Reached target Multi-User System.
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Reached target Graphical Interface.
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]:          Starting Record Runlevel Change in UTMP...
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Started Network Name Resolution.
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Reached target Host and Network Name Lookups.
Jan 17 20:47:55 uhost1 systemd-nspawn[16314]: [  OK  ] Finished Record Runlevel Change in UTMP.
Jan 17 20:47:56 uhost1 systemd-nspawn[16314]: 
Jan 17 20:47:56 uhost1 systemd-nspawn[16314]: Ubuntu 22.04 LTS uhost1 console
Jan 17 20:47:56 uhost1 systemd-nspawn[16314]:
```

> *Команда виводить статус служби.*
> 

**sudo machinectl login jammy**

```jsx
Connected to machine jammy. Press ^] three times within 1s to exit session.

Ubuntu 22.04 LTS uhost1 pts/1

uhost1 login: root
Password: 
Welcome to Ubuntu 22.04 LTS (GNU/Linux 5.15.0-91-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@uhost1:~#
```

> *Команда для входу в контейнер або віртуальну машину.*
>