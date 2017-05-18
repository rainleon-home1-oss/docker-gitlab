#!/usr/bin/env bash

# see: https://github.com/jwilder/dockerize

mkdir -p /data/ssh
mkdir -p /data/gitlab

. /app/gitlab/git_init.sh

case $1 in
    "init_git")
        init_git
        ;;
    "export_git_admin_key")
        export_git_admin_key
        ;;

    "export_git_deploy_key")
        export_git_deploy_key
        ;;

    *)
        echo -e "Usage: $0 param
    param are follows:
        init_git
        export_git_admin_key   export git admin user's key (ssh private key)
        export_git_deploy_key  export git project's deploy key (ssh public key)
        args                   pass to service entry point.
                               gitlab's default is: /bin/s6-svscan /app/gitlab/docker/s6/
        "
        if [ -f "/app/gitlab/data/.lock_git_init" ] && [ "true" == "${GIT_INIT_SKIP}" ] ; then
            echo "skip git init step as GIT_INIT_SKIP=${GIT_INIT_SKIP} and already init at least once"
        else
            init_git & echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
        fi
        echo "start git service"
        exec "$@"
        ;;
esac
