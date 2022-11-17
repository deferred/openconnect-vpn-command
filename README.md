# vpn.sh

vpn.sh is a shell script to simplify OpenConnect VPN client experience.

## Installation

1. Install OpenConnect and vpn-slice `brew install openconnect vpn-slice`
2. `mkdir -p ~/.openconnect`
3. `cp connection-info.env ~/.openconnect`
4. Modify ` ~/.openconnect/connection-info.env`
5. `sudo cp ${PWD}/vpn.sh /usr/local/bin/vpn`

## Usage

```bash
# shows available commands
vpn

# starts vpn
sudo vpn start

# stops vpn
sudo vpn stop

# shows vpn status
sudo vpn status

# restarts vpn
sudo vpn restart
```

Logs are available at `/tmp/openconnect.log`