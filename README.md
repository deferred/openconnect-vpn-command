# vpn.sh

vpn.sh is a shell script to simplify OpenConnect VPN client experience.

## Installation

1. Install OpenConnect using your preferred package manager `brew install openconnect`
2. `mkdir -p ~/.openconnect`
3. `cp connection-info.env ~/.openconnect`
4. Modify ` ~/.openconnect/connection-info.env` with your credentials
5. `sudo cp vpn.sh /usr/local/bin/vpn`

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