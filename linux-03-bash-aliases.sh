#!/bin/bash
ALIASES=$(cat << 'EOF'
# docker functions/aliases
function dcuuf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "⬆️ Upgrading $SESSION_DOCKER_NAME to $2";
    sed -i -E "s/image:(.*):.*/\image:\1:$2/" ./$SESSION_DOCKER_NAME/docker-compose.yml;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml up -d --remove-orphans;
}
function dcpf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "📦 Pulling images for $SESSION_DOCKER_NAME";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml pull;
}
function dcuf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🚀 Bringing up $SESSION_DOCKER_NAME";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml up -d --remove-orphans;
    curl https://auto.trinitro.io/webhook/traefik-proxy; echo
}
function dcdf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🛑 Bringing down $SESSION_DOCKER_NAME";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml down -t 120;
    curl https://auto.trinitro.io/webhook/traefik-proxy; echo
}
function dcrf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🔄 Restarting $SESSION_DOCKER_NAME";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml restart -t 120;
}
function dclf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "📜 Following logs for $SESSION_DOCKER_NAME";
    docker logs $SESSION_DOCKER_NAME --follow;
}
function dcef() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🔧 Cracking into $SESSION_DOCKER_NAME ${2-bash}";
    docker exec -it $SESSION_DOCKER_NAME /bin/${2-bash}
}
alias dip='docker image prune -af'

EOF
)
echo "$ALIASES" | tee ~/.bash_aliases
ALIAS_SNIPPET='if [ -f ~/.bash_aliases ]; then
.  ~/.bash_aliases
fi'
grep -qxF "$ALIAS_SNIPPET" ~/.bashrc || echo "$ALIAS_SNIPPET" >> ~/.bashrc
source ~/.bashrc
# For synology or any system use old version of docker-compose
# sed -i 's/docker compose/docker-compose/g' ~/.bash_aliases