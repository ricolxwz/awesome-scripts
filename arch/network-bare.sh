echo '
alias proxy="
    export http_proxy=http://127.0.0.1:5353;
    export https_proxy=http://127.0.0.1:5353;
    export all_proxy=http://127.0.0.1:5353;
    export no_proxy=http://127.0.0.1:5353;
    export HTTP_PROXY=http://127.0.0.1:5353;
    export HTTPS_PROXY=http://127.0.0.1:5353;
    export ALL_PROXY=http://127.0.0.1:5353;
    export NO_PROXY=http://127.0.0.1:5353;"
alias unproxy="
    unset http_proxy;
    unset https_proxy;
    unset all_proxy;
    unset no_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset ALL_PROXY;
    unset NO_PROXY"
' >> ~/.bashrc
source ~/.bashrc

ip r
ip a

sudo systemctl enable sshd
sudo systemctl start sshd

mkdir -p ~/.ssh

echo "1: Github private key (using ed25519 encryption, enter EOF to execute): "
ssh_private_key_1=""
while IFS= read -r line; do
    if [ "$line" == "EOF" ]; then
        break
    fi
    ssh_private_key_1+="$line"$'\n'
done
if [ -n "$ssh_private_key_1" ]; then
    echo "$ssh_private_key_1" > ~/.ssh/id_ed25519_1
    chmod 400 ~/.ssh/id_ed25519_1
else
    echo "Pass."
fi

echo "2: Github private key (using ed25519 encryption, enter EOF to execute): "
ssh_private_key_2=""
while IFS= read -r line; do
    if [ "$line" == "EOF" ]; then
        break
    fi
    ssh_private_key_2+="$line"$'\n'
done
if [ -n "$ssh_private_key_2" ]; then
    echo "$ssh_private_key_2" > ~/.ssh/id_ed25519_2
    chmod 400 ~/.ssh/id_ed25519_2
else
    echo "Pass."
fi

echo "[user]
name = wenzexu" > ~/.gitconfig

echo "Host gh1
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_1

Host gh2
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_2" > ~/.ssh/config

sudo systemctl restart sshd
