#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# init-firewall.sh — Default-deny outbound firewall for Claude Code sandbox
#
# Whitelists only the domains Claude Code needs (API, telemetry, error reporting)
# plus host gateway access for PostgreSQL and the dev server.
# DNS is restricted to Docker's embedded resolver to prevent tunneling.
#
# Requires NET_ADMIN capability (set in devcontainer.json).
# Exits non-zero if firewall validation fails.
# =============================================================================

# Detect the container's DNS resolver (varies by Docker environment)
DOCKER_DNS=$(awk '/^nameserver/ { print $2; exit }' /etc/resolv.conf)
if [ -z "$DOCKER_DNS" ]; then
    DOCKER_DNS="127.0.0.11"  # fallback to Docker embedded DNS
fi

# Host gateway IP — resolve host.docker.internal (IPv4 only)
HOST_GATEWAY=$(getent ahostsv4 host.docker.internal 2>/dev/null | awk 'NR==1{ print $1 }')
if [ -z "$HOST_GATEWAY" ]; then
    echo "ERROR: Could not resolve host.docker.internal to an IPv4 address"
    exit 1
fi

# Domains to whitelist (Claude Code requirements)
ALLOWED_DOMAINS=(
    "api.anthropic.com"
    "statsig.anthropic.com"
    "sentry.io"
)

echo "=== Initializing firewall ==="
echo "Host gateway: $HOST_GATEWAY"
echo "Docker DNS:   $DOCKER_DNS"

# Flush existing rules
iptables -F OUTPUT

# --- OUTPUT chain rules ---

# 1. Allow established/related connections
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 2. Allow loopback
iptables -A OUTPUT -o lo -j ACCEPT

# 3. Allow DNS only to Docker's embedded resolver
iptables -A OUTPUT -d "$DOCKER_DNS" -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -d "$DOCKER_DNS" -p tcp --dport 53 -j ACCEPT

# 4. Allow host gateway — PostgreSQL (5432) and dev server (3000)
iptables -A OUTPUT -d "$HOST_GATEWAY" -p tcp --dport 5432 -j ACCEPT
iptables -A OUTPUT -d "$HOST_GATEWAY" -p tcp --dport 3000 -j ACCEPT

# 5. Resolve and allow whitelisted domains
for domain in "${ALLOWED_DOMAINS[@]}"; do
    ips=$(dig +short "$domain" 2>/dev/null | grep -E '^[0-9]+\.' || true)
    if [ -z "$ips" ]; then
        echo "WARNING: Could not resolve $domain — skipping"
        continue
    fi
    for ip in $ips; do
        iptables -A OUTPUT -d "$ip" -p tcp --dport 443 -j ACCEPT
        echo "  Allowed: $domain -> $ip:443"
    done
done

# 6. Default deny — set chain policy to DROP (defense-in-depth)
iptables -P OUTPUT DROP

# 7. Block all IPv6 egress
ip6tables -F OUTPUT
ip6tables -P OUTPUT DROP

# --- Validate ---
echo ""
echo "=== Firewall rules ==="
iptables -L OUTPUT -n --line-numbers

# Minimum expected: ESTABLISHED + loopback + 2 DNS + 2 host gateway = 6 ACCEPT rules
RULE_COUNT=$(iptables -L OUTPUT -n | grep -c -E '^ACCEPT')
if [ "$RULE_COUNT" -lt 6 ]; then
    echo "ERROR: Firewall validation failed — only $RULE_COUNT ACCEPT rules found (expected >= 6)"
    exit 1
fi

echo ""
echo "=== Firewall initialized successfully ($RULE_COUNT rules, policy DROP) ==="
