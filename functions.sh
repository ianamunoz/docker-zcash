# backup files from a docker volume into /tmp/backup.tar.gz
function backup-docker-volume() {
 docker run --rm \
 --mount source=$1,destination=/volume -v $2:/backup debian:jessie \
 tar -czvf /backup/$1.tar.gz -C /volume ./
}

function restore-docker-volume() {
docker run --rm -v $1:/volume -v $PWD:/backup debian:jessie \
	    sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]* ; tar -C /volume/ -xzvf /backup/$2"
}

function docker-volume-backup-compressed() {
  docker run --rm -v "$2":/backup --volumes-from "$1" debian:jessie tar -czvf /backup/backup.tar.gz "${@:3}"
}
# restore files from /tmp/backup.tar.gz into a docker volume
function docker-volume-restore-compressed() {
  docker run --rm -v /tmp:/backup --volumes-from "$1" debian:jessie tar -xzvf /backup/backup.tar.gz "${@:2}"
  echo "Double checking files..."
  docker run --rm -v /tmp:/backup --volumes-from "$1" debian:jessie ls -lh "${@:2}"
}

dvolume() {
  local volume volumes_to_list=${1:-$(docker volume ls --quiet)}
  for volume in $volumes_to_list; do
    sudo ls -lRa "$(docker volume inspect --format '{{ .Mountpoint }}' "$volume")"
    echo
  done
}
