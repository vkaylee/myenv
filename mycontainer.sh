#!/usr/bin/env zsh
myContainer() {
    docker-compose --project-directory "${MYENV_DIR}" --file "${MYENV_DIR}/container.docker-compose.yml" --project-name "container" "${@}"
}

myContainerConfigServices() {
    myContainer config --services
}

function usage() {
    echo "$(basename "${0}") [action]"
    echo "----------- actions -----------"
    echo "up [service]: Up service on local"
    echo "exec [service] <shell name>: Get in the service container"
    echo "down: Cleanup all services"
    echo "down [service]: Cleanup the service"
    echo "ps|ls: Show running services"
    echo "----------- services ----------"
    myContainer config --services | while IFS="\n" read -r service
    do
        echo "-- ${service}"
    done 
    echo
}


myContainerShowWrongServices() {
    local inputService
    inputService="${1}"
    local services
    services=$(myContainerConfigServices)
    showUsage(){
        echo "Please try with: [service]"
        local count=0
        echo "${services}" | while IFS="\n" read -r service
        do
            ((count+=1))
            echo "${count}) ${service}"
        done
    }
    if [ -z "${inputService}" ]; then
        showUsage
        return 1
    fi
    local isServiceExistent="false"
    echo "${services}" | while IFS="\n" read -r service
    do
        if [ "${service}" = "${inputService}" ]; then
            isServiceExistent="true"
            break
        fi
    done
    if [ "${isServiceExistent}" = "false" ]; then
        showUsage
        return 1
    fi
}

myContainerUp() {
    local inputService
    inputService="${1}"
    if ! myContainerShowWrongServices "${inputService}"; then
        return 1
    fi
    # Check running
    myContainer ps --services | while IFS="\n" read -r runningService
    do
        if [ "${runningService}" = "${inputService}" ]; then
            return 0
        fi
    done
    myContainer up -d "${inputService}"
}

myContainerExec() {
    local inputService
    inputService="${1}"
    if ! myContainerShowWrongServices "${inputService}"; then
        return 1
    fi
    myContainerUp "${inputService}"
    local inputShell="${2}"
    if [ -z "${inputShell}" ]; then
        echo "Default bash shell will be used"
        inputShell="bash"
    fi
    echo "Exec into ${inputService} with ${inputShell} shell"
    myContainer exec -u 0 "${inputService}" "${inputShell}"
}

myContainerDown() {
    local service="${1}"
    if [ -z "${service}" ]; then
        myContainer down
        return
    fi
    if ! myContainerShowWrongServices "${service}"; then
        return 1
    fi
    # -f, --force     Don't ask to confirm removal
    # -s, --stop      Stop the containers, if required, before removing
    # -v, --volumes   Remove any anonymous volumes attached to containers
    myContainer rm -s -v -f "${service}"
}




myContainerMain-479ba3472071fe003c48f3806f6d58fb4cf5ce9101af532f114604038b7495c0() {
    local action="${1}"
    local service="${2}"
    local shell="${3}"
    case "${action}" in
        up)
            myContainerUp "${service}";;
        down)
            myContainerDown "${service}";;
        exec)
            myContainerExec "${service}" "${shell}";;
        ls|ps)
            myContainer ps;;
        *)
            usage
            ;;
    esac
}

set_command_aliases 'mycontainer,myc' 'myContainerMain-479ba3472071fe003c48f3806f6d58fb4cf5ce9101af532f114604038b7495c0' 'Create OS environment in container'