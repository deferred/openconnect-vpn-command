# vpn.sh

vpn.sh is a shell script to simplify openconnect experience.

## Installation

1. Install openconnect using your preferred package manager `brew install openconnect`
2. `mkdir -p ~/.openconnect`
3. `cp connection-info.env ~/.openconnect/`
4. Modify ` ~/.openconnect/connection-info.env` with your credentials
5. Put `vpn` in your PATH `ln -s vpn.sh ~/.local/bin/vpn`

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