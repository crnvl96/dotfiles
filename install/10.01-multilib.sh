
# Check if multilib is already enabled
if grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Multilib repository is already enabled."
else
    # Append multilib configuration to pacman.conf
    sudo tee -a /etc/pacman.conf >/dev/null <<EOF

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
    echo "Multilib repository has been enabled in /etc/pacman.conf."
    sudo pacman -Syu
fi
