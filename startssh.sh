#/bin/bash
keyfile=${1:-~/.ssh/id_rsa.pub}
user=jovyan
port=2222 

if [[ ! -a $keyfile ]]; then
   echo "No keyfile: $keyfile"
   keyfile=""
fi

docker ps 
read -p "Enter Container id: " id

docker exec -u 0  $id /bin/bash -c 'echo -e "AddressFamily inet\nStrictModes no" >> /etc/ssh/sshd_config'

if [[ -n $keyfile ]]; then
    docker exec  $id /bin/bash -c "mkdir /home/$user/.ssh"
    docker exec -i $id /bin/bash -c "cat > /home/$user/.ssh/authorized_keys" < $keyfile 
fi

docker exec -u 0 -it $id service ssh stop
docker exec -u 0 -it $id service ssh start

# big f'ing hack to compenstate for default bashrc not having conda in path.
# Not sure how jupyter does this but some how it is in path before bashrc starts
docker exec -u jovyan $id  bash -c 'cp .bashrc .bashrc.old; echo -e "#JA HACK\nexport PATH=\$PATH:/opt/conda/bin" > .bashrc; cat .bashrc.old >> .bashrc'

 
echo "This should now work:"

echo "To make life easier you might want to add the following to your ssh config"
echo "Host localhost
       StrictHostKeyChecking no
       UserKnownHostsFile=/dev/null"

echo "ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p $port -i ${keyfile%%.pub} $user@localhost"
echo "ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p $port -i ${keyfile%%.pub} $user@localhost xterm"
echo "ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p $port -i ${keyfile%%.pub} $user@localhost inkscape"

