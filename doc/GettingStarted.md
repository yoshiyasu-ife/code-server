# Getting Started - Setup Guide

For this guide, we'll be showing our recommended setup and configuration process for running `code-server` on a remote machine.

For simplicity, we'll be using Google Cloud Platform to host our remote machine. Similar setups on Amazon Web Services or other cloud providers should work with small modifications.

### 1. Create a Virtual Machine in your Google Cloud Console
We recommend using Ubuntu with at least 2 vCPU and 4GB of memory


![create_vm](https://user-images.githubusercontent.com/7585078/78195610-b535f880-7445-11ea-956f-6b16a8e4daf0.png)
![configure_vm](https://user-images.githubusercontent.com/7585078/78195622-c252e780-7445-11ea-8abc-f92dfb877d4b.png)


### 2. SSH into your Virtual Machine
SSH into your new remote machine. All subsequent steps should take place in your ssh session.


![ssh_into_vm](https://user-images.githubusercontent.com/7585078/78195647-d4348a80-7445-11ea-9e13-5389b6f42fea.png)


### 3. Install code-server
```
curl -s https://raw.githubusercontent.com/cdr/code-server/issue-1396/install_linux.sh | bash -s
```

You may need to add `$HOME/bin` to your path.
Simply add `export PATH=$PATH:$HOME/bin` to your `.bashrc`

### 4. Configure your start scripts
To run `code-server` on port `80`, you'll first need to give the `code-server` executable elevated permissions.
```
sudo setcap cap_net_bind_service=+ep $HOME/lib/code-server/code-server
```

To allow `code-server` to restart in the case of crashes, we recommend using a simple bash script similar to the one shown below. Note: the `PASSWORD` environment variables is how you'll authenticate when using code-server from your browser.

**`start-code-server.sh`**
```bash
#!/bin/bash
while true
do

PASSWORD=testing123 code-server \
	--host 0.0.0.0 \
	--port 80 .

sleep 3
done
```

### 5. Start `code-server`
To allow `code-server` to run in the background, execute the script above in a `screen`.
```
screen -d -m sh start-code-server.sh
```

You can now safely exit you `ssh` session.


### 6. Allocate a static IP for your Google Cloud VM

Inside the Google Cloud Console, allocate a static IP address for your virtual machine. This is how you'll access `code-server` from the browser.

![reserve_static_ip](https://user-images.githubusercontent.com/7585078/78196007-bae00e00-7446-11ea-9089-e0b493a0b151.png)

### 7. Open `code-server` in your browser

Naviate to your newly allocated static IP address in the browser.

### 8. Install the Chrome app

To improve your development experience, download the Chrome web app.
