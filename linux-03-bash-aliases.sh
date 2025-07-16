#!/bin/bash
ALIASES=$(cat << 'EOF'
# docker / docker compose
function dcuuf() {
    echo "🚀 Upgrading $1 to $2";
    sed -i -E "s/image:(.*):.*/\image:\1:$2/" ./$1/docker-compose.yml;
    export HOSTNAME;
    docker compose -f ./$1/docker-compose.yml up -d;
}
function dcpf() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "📦 Pulling images for $SESSION_DOCKER_NAME";
    export HOSTNAME;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml pull;
}
function dcuf() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🚀 Bringing up $SESSION_DOCKER_NAME";
    export HOSTNAME;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml up -d --remove-orphans;
}
function dcdf() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🛑 Bringing down $SESSION_DOCKER_NAME";
    export HOSTNAME;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml down -t 120;
}
function dcrf() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🔄 Restarting $SESSION_DOCKER_NAME";
    export HOSTNAME;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml restart -t 120;
}
function dclf() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "📜 Following logs for $SESSION_DOCKER_NAME";
    docker logs $SESSION_DOCKER_NAME --follow;
}
function dcef() {
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    echo "🔧 Cracking into $SESSION_DOCKER_NAME ${2-bash}";
    docker exec -it $SESSION_DOCKER_NAME /bin/${2-bash}
}
alias dcu='docker compose up -d'
alias dcd='docker compose down -t 120'
alias dip='docker image prune -af'
alias diu='docker inspect $(docker ps -q) --format "{{.Config.User}} {{.Name}}"'

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