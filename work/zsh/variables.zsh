# Export work specific environment variables
export BROWSER='google-chrome'

# No GPG on the work box: plain ssh-agent on a fixed socket instead of
# gpg-agent's (zshrc sets that one first; this overrides it).
# ssh-add -l exits 2 only when no agent answers on the socket.
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
ssh-add -l >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
  rm -f "$SSH_AUTH_SOCK"
  ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
fi

# Zscaler re-signs TLS; tools with their own CA bundle must use the system one.
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
