<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Setup Guide

- [Machine](#machine)
  - [Requirements](#requirements)
- [Install](#install)
- [Authentication](#authentication)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

This guide will explain how to setup and use code-server. To reiterate, code-server
lets you run VS Code on a remote server and then access it via a browser.

See the [README](../README.md) for a general overview and the [FAQ](./FAQ.md) for further docs.

## Machine

First, you need a machine to run code-server on. You can use a physical
machine you have lying around or use a VM on GCP/AWS.

### Requirements

- 64-bit OS
- At least 1 GB of RAM.
- At least 2 cores
- For Linux: GLIBC >= v2.17 and GLIBCXX >= 3.4.15

You can use whatever linux distribution floats your boat.

## Install

You can manually install by downloading from our
[releases page](https://github.com/cdr/code-server/releases) but the below options are more convenient.

### Linux

```bash
curl --silent https://raw.githubusercontent.com/cdr/code-server/issue-1396/install_helper.sh | bash
```

The above script will download the latest release of code-server into
`~/.local/share/code-server/<version>`. It will symlink the installed release into
`~/.local/bin/code-server` so you'll need to make sure you have `~/.local/bin` in `$PATH`.

### Mac

**We are working on this in [#1542](https://github.com/cdr/code-server/issues/1542).**

```bash
brew install code-server
```

## Operation

There are several approaches to operating and exposing code-server.

Since you can gain access to a terminal from within code-server, never, ever
expose it directly to the internet without some form of authentication and encryption.

By default, code-server will always enable password authentication which will
require you to copy the password from the code-server output to access it. You
can set a custom password with $PASSWORD.

With all that said, let's go through some secure setups.

**note**: You can list the full set of code-server options with `code-server --help`

### SSH

A very secure and convenient approach is with [sshcode](https://github.com/codercom/sshcode) ([FAQ](https://github.com/cdr/code-server/blob/setup/doc/FAQ.md#sshcode))
to start code-server on any Linux machine over SSH. We highly recommend this unless you
need to access code-server from a machine without ssh such as an iPad.

### Self Signed

This example shows how to run code-server with a self signed certificate.
You'll get a warning when accessing but if you click through you should be good.

```bash
./code-server --host 0.0.0.0 --cert --port 8080
```

Now, visit `https://<your-server-ip>:8080` to access code-server.

**note:** Self signed certificates do not work with iPad and will cause a blank page so check out the Domain section below

#### mkcert

You can use [mkcert](https://github.com/FiloSottile/mkcert) if you want a self signed
certificate automatically trusted by your operating system:

You'd run `mkcert` locally to generate the certificate:

```
mkcert <server-ip>
```

And then transfer the certificate and key file to your server and run:

```bash
./code-server --host 0.0.0.0 --cert=<server-ip>.pem --cert-key=<server-ip>-key.pem --port 8080
```

### Domain

Let's say you don't want to use a self signed certificate like in the basic example. In order to
get a non self signed certificate, you'll need a domain name.

The easiest way is to put cloudflare in front of code-server and have it

1. You can put cloudflare in front of code-server and have it act as a proxy for all requests
    - It will fetch the TLS certificate for you so you don't have to manage anything
    - We highly recommend this approach as it requires very little effort on your part, just sign
      up for cloudflare and follow their instructions
1. You can put nginx or another proxy in front and use their letsencrypt integrations
1. You could generate a single one off letsencrypt

### Persistence?

So the above examples only demonstrate how to execute `code-server` from a terminal but you really
want to use your operating system's init system to manage code-server. i.e systemd for Linux, launchd
for macOS etc.

Here's an example systemd unit file:

```
[Unit]
Description=code-server
After=network.target

[Service]
ExecStart=/usr/local/bin/code-server
Restart=always

[Install]
WantedBy=multi-user.target
```

Depends on your platform/distribution.

## How do I securely access web services?

See the [FAQ](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#how-do-i-securely-access-web-services).
