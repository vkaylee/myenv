#!/usr/bin/env bash
set -e
# Run the test with the input is one of 
oses=()
test_oses=("debian" "ubuntu" "fedora")
# if input is not empty
if [[ -n "${1}" ]]; then
    for test_os in "${test_oses[@]}"; do
        if [[ "${1}" == "${test_os}" ]]; then
            oses+=("${1}")
        fi
    done
else
    for test_os in "${test_oses[@]}"; do
        oses+=("${test_os}")
    done
fi

trap "docker compose down" EXIT

for os in "${oses[@]}"; do
    echo "Test for ${os}"
    docker compose down
    docker compose build "${os}"
    docker compose up -d "${os}"
    sleep 30 # delay a bit for sure all things are ready
    docker compose exec "${os}" /ci_test.sh docker http://file-server/files http://file-server/vleedev/myenv.git
done

