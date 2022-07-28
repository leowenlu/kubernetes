
#!/bin/bash -e

usage() {
    cat << EOF
usage: $(basename "$0") -f <env_file_name>
* env_file_name           [required] environment file path
EOF
    exit 1
}

while getopts ":f:" o
  do
  case "${o}" in
    f) env_file_name=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z "${env_file_name}" ]]; then
  usage
fi

unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  lines=$(grep -v '^#' ${env_file_name} | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ]; then
  lines=$(grep -v '^#' ${env_file_name} | xargs -0)
  #export $line
fi

for line in $lines;
  do
    export $line
    #echo $line
  done
