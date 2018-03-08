---
title: Making a Home Server from an Old Computer
date: 2017-07-25
intro: Have an old computer and a need a website? Find out how easy it is to host your own.
---

I have an oldish computer which just sat and sat and sat. Nobody should waste all that CPU and RAM and disk space. On top of that, I had GoDaddy shared hosting, which doesn't allow `sudo` privileges. (I'd recommend an Amazon EC2 instance if you're shopping for remote server hosting.) I decided to make a server.

Here are the problems:
- Windows
- Home WiFi
- Windows

### First Thing's First

Remove Windows. I'm not dealing with PowerShell (or god forbid... Command Prompt). I had previously installed Elementary OS, which is basically a lighter version of Ubuntu, and I'd liked it very much.

#### Windows

Step 1: Install [Rufus](https://rufus.akeo.ie/).

Step 2: Download the most recent Elementary OS .ISO from Elementary's [page](https://elementary.io/).

Step 3: Use Rufus to load the ISO on to the drive.

#### Mac

You can use [UNetbootin](https://unetbootin.github.io/), but I had problems with that. You can use the much more raw Mac Terminal `dd` command instead. There's a great guide [here](http://osxdaily.com/2015/06/05/copy-iso-to-usb-drive-mac-os-x-command/).

### Installing

On the target machine, plug in the USB and shutdown the computer (doing it in the opposite order is ok too). When the computer starts to boot, it will give you some options on the screen as it loads. Try to look for **BIOS** or **Startup Options** or something similar. This will allow you to boot from the drive. At the BIOS menu, find the option that allows you to boot from USB. Then Elementary OS will boot up and help you install.

I recommend using the whole disk as space and overwriting all memory. If you want to keep windows, you can partition the drive before booting into Elementary. If you only have Elementary OS installed, you can easily set up a direct boot to the home screen, which will allow you to restart you machine from afar. During the setup you will have the option to automatically log in. This is a bad idea if you're going to use the computer as a general purpose laptop, but as a server this is a great idea. Again, this will allow you to restart the machine from a remote SSH connection without manual interference.

Once you're on Elementary, open up settings and change the power settings to never sleep and "Do Nothing" on lid shut.

Open up the terminal.

```shell
$ sudo apt update
... lots of dialogue
$ sudo apt full-upgrade
```

This will allow you access to all modern packages. Now start up SSH on the machine so you can log in remotely.

```shell
$ sudo apt install openssh-client openssh-server
$ sudo service ssh restart
$ ssh-keygen -t ecdsa -b 521
```

That allows you to log in remotely. `ssh-keygen` makes a new ssh key, allowing you to log into other machines _from_ the server. I prefer `ecdsa`, which is based on elliptical curve key cryptography, and `521` is the largest bit size supported commonly for `ecdsa`.

```shell
$ sudo apt install git nginx fail2ban iptables nodejs-legacy
```

These are some really necessary packages. `fail2ban` and `iptables` improve security.

Going into installing all of these services would be really repetitive because Digital Ocean has some great and in depth tutorials.

- [Nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04)
- [Nginx and Node (reverse proxying)](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04)
- [HTTPS connections with Certbot](https://www.digitalocean.com/community/tutorials/how-to-use-certbot-standalone-mode-to-retrieve-let-s-encrypt-ssl-certificates)
- [Page performance with compression](https://www.digitalocean.com/community/tutorials/how-to-increase-pagespeed-score-by-changing-your-nginx-configuration-on-ubuntu-16-04)

### Becoming a Server

Once all the web-app stuff is set up, there's still the problem that your computer is on home WiFi. That means in the broad reaches of the internet, you can't be found by DNS. You can change this by changing some router settings.

In order to make your computer 'public', you need to **port forward**. This allows you to send and receive traffic through your router like sending water through a pipeline.

Step 1: Access your router. This is probably by going into your browser and typing in the URL bar: `http://192.168.1.1`. This should lead you to the router, where you can sign in with its name and password.

Step 2: Find the **WAN** page. The Wide Area Network settings are the most likely place to find the port forwarding options. Consult Google for your specific router.

Step 3: Find the Static IP settings. You should have an option to give (maybe up to 64) computers their own static IP address based on their MAC address. Consult the router's home page for those numbers (the Client List page). Bestow your server it's own static IP address and write it down.

Step 4: Find the port forwarding settings. Consult Google.

Step 5: Forward ports `80`, `443`, and `22`. `80` is HTTP. `443` is HTTPS. `22` is SSH.

Step 6: Test. Find your external IP address. I do `curl ifconfig.me`, although there are security concerns over this method. Enter that address in your browser. Start your Node app.

Step 7: Move DNS records. Set the IP address to the IP address you found in step 6.

Step 8: **Victory**.
