#!/bin/bash

clear
echo "┌────────────────────────────────────────────────────────────────────────────┐"
echo "│   ██████╗██████╗ ██╗   ██╗████████╗██████╗ ████████╗ ██████╗ ███╗   ███╗    │"
echo "│  ██╔════╝██╔══██╗██║   ██║╚══██╔══╝██╔══██╗╚══██╔══╝██╔═══██╗████╗ ████║    │"
echo "│  ██║     ██████╔╝██║   ██║   ██║   ██████╔╝   ██║   ██║   ██║██╔████╔██║    │"
echo "│  ██║     ██╔═══╝ ██║   ██║   ██║   ██╔═══╝    ██║   ██║   ██║██║╚██╔╝██║    │"
echo "│  ╚██████╗██║     ╚██████╔╝   ██║   ██║        ██║   ╚██████╔╝██║ ╚═╝ ██║    │"
echo "│   ╚═════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚═╝     ╚═╝    │"
echo "│                                                                            │"
echo "│            🚀 Gensyn Node Installer | Powered by CryptoMate               │"
echo "└────────────────────────────────────────────────────────────────────────────┘"
echo ""

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl git wget unzip tmux

# Download & Install Gensyn node
cd $HOME
rm -rf gensyn-node
git clone https://github.com/GensynAI/gensyn-node.git
cd gensyn-node
cargo build --release

# Create systemd service (optional)
sudo tee /etc/systemd/system/gensyn.service > /dev/null <<EOF
[Unit]
Description=Gensyn Node by CryptoMate
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/gensyn-node/target/release/gensyn-node
Restart=on-failure
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable gensyn
sudo systemctl start gensyn

echo ""
echo "✅ Gensyn Node installed and running!"
echo "🔁 To check logs: journalctl -fu gensyn -o cat"
