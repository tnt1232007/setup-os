#!/bin/bash
ALIASES=$(cat << 'EOF'
# docker functions/aliases
function dcuuf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "⬆️ Upgrading $SESSION_DOCKER_NAME to $2...";
    sed -i -E "s/image:(.*):.*/\image:\1:$2/" ./$SESSION_DOCKER_NAME/docker-compose.yml;
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml up -d --remove-orphans;
}
function dcpf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "📦 Pulling images for $SESSION_DOCKER_NAME...";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml pull;
}
function dcuf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "🚀 Bringing up $SESSION_DOCKER_NAME...";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml up -d --remove-orphans;
    echo "⏳ Waiting for $SESSION_DOCKER_NAME proxy...";
    if [ "$HOSTNAME" = "vm-system" ]; then
        TRAEFIK_HOST="proxy.trinitro.io";
    else
        TRAEFIK_HOST="proxy-$HOSTNAME.trinitro.io";
    fi
    for i in {1..60}; do
        echo -ne "\r[+] Checking $TRAEFIK_HOST $i/60"
        RESPONSE=$(curl -sf https://$TRAEFIK_HOST/api/http/routers/$SESSION_DOCKER_NAME@docker)
        if [ $? -eq 0 ]; then
            curl -sf https://auto.trinitro.io/webhook/traefik-proxy > /dev/null
            HOST=$(echo "$RESPONSE" | grep -oP 'Host\(`\K[^`]+')
            echo -ne "\r[+] Checking $HOST $i/60"
            ping -c 1 "$HOST" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "\r[+] Checking $HOST $i/$i                      "
                echo -e " \033[0;32m✔\033[0m Proxy $SESSION_DOCKER_NAME  \033[0;32mAvailable\033[0m"
                break
            fi
        fi
        if [ $i -eq 60 ]; then
            echo -e "\r[+] Checking $TRAEFIK_HOST 60/60"
            echo -e " \033[0;31m✖\033[0m Proxy $SESSION_DOCKER_NAME  \033[0;31mTimed out\033[0m"
            break
        fi
        sleep 1
    done
}
function dcdf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "🛑 Bringing down $SESSION_DOCKER_NAME...";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml down -t 120;
}
function dcrf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "🔄 Restarting $SESSION_DOCKER_NAME...";
    docker compose -f ./$SESSION_DOCKER_NAME/docker-compose.yml restart -t 120;
}
function dclf() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "📜 Following logs for $SESSION_DOCKER_NAME...";
    docker logs $SESSION_DOCKER_NAME --follow;
}
function dcef() {
    export HOSTNAME;
    export SESSION_DOCKER_NAME="${1:-$SESSION_DOCKER_NAME}"
    export SESSION_DOCKER_NAME="${SESSION_DOCKER_NAME%/}"
    echo "🔧 Cracking into $SESSION_DOCKER_NAME ${2-bash}...";
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