#!/usr/bin/env bash
set -e

if [ -z "$2" ]; then
    echo "Usage: $0 <client_name> [client_ipv6]"
    echo "Example: $0 macbook fd3a:bf0b:57ce::2"
    exit 1
fi

CLIENT_NAME=$1
CLIENT_IP6=${2:-""}

# Update these with your rosetta server's details
SERVER_PUBKEY="spAIyvwsnZyqb/E5Am8FMnxDgDBNR5uh4XK35GgRvnY="
SERVER_ENDPOINT="125.228.136.19:54088"

PRIV_KEY=$(wg genkey)
PUB_KEY=$(echo "$PRIV_KEY" | wg pubkey)

echo "=========================================="
echo "1. CLIENT CONFIGURATION (${CLIENT_NAME}.conf)"
echo "=========================================="
tee ${CLIENT_NAME}.conf <<EOF
[Interface]
PrivateKey = $PRIV_KEY
Address = ${CLIENT_IP6/128/}

[Peer]
PublicKey = $SERVER_PUBKEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = fd08::/16
EOF

printf "\033]1337;File=inline=1;preserveAspectRatio=1:%s\a\n" "$(qrencode -o - -t PNG <"${CLIENT_NAME}.conf" | base64 -w0)"

echo ""
echo "=========================================="
echo "2. NIXOS SERVER CONFIGURATION (Add to rosetta)"
echo "=========================================="
cat <<EOF
{
  # $CLIENT_NAME
  PublicKey = "$PUB_KEY";
  AllowedIPs = [
    "${CLIENT_IP6}/128"
  ];
}
EOF
