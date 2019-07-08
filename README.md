
# Create a Linux Service

Based on [Creating a Linux service with systemd](https://medium.com/@benmorel/creating-a-linux-service-with-systemd-611b5c8b91d6)

## Perl Script

Using reverse-service.pl.  This script just reverses everthing received and sends it back to the client

## Test the script

In one window

```bash
./reverse-service.pl
```

Then in another window:

```bash
nc 0.0.0.0 4242
```

or if netcat is not allowed, install and use telnet

```bash
telnet -e \\  poirot 4242
```

Now type some lines in the client window

If using netcat, just enter CTL-C.

For teslnet, exit to telnet command mode by pressing \.

Enter 'quit' to exit.


## Setup the service


Create the following as /etc/systemd/system/reverse-text.service

```bash
[Unit]
Description=Reverse Text demo service
After=network.target
# Not used in Ubuntu 18
#StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=jkstill
ExecStart=/usr/bin/env perl /home/jkstill/linux/systemd-service-example/reverse-service.pl

[Install]
WantedBy=multi-user.target
```

```bash
systemctl start reverse-text
```

To make the service permanent (start at reboot)

```bash
systemctl enable reverse-text
```

