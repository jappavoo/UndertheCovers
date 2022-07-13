#/bin/bash
uid=$(cat base/ope_uid)

if [[ $1 == -h ]]; then
    echo "USAGE: $0 [uid]"
    echo "   attach to a running container as the specified uid default is default id: $uid"
    exit -1
fi

[[ -n $1 ]] && uid=$1

docker ps 
read -p "Enter Container id: " id
docker exec -u $(uid) -it $id /bin/bash
