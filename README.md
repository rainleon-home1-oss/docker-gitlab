# docker-gitlab
Gitlab in docker


## gitlab


1. 宿主机目录

        mkdir -p ${HOME}/data/gitlab/config && mkdir -p ${HOME}/data/gitlab/data && mkdir -p ${HOME}/data/gitlab/logs

        # 注意，gitlab/docker/deploy_key.pub 用来向gitlab添加configserver应用的ssh key，这里默认会添加一组公私钥:
        # 如果有新的需求需要添加新的可以通过web界面：http://gitlab.XXXXX/group_name/repo_name/settings/repository: Deploy Keys 添加，当然也可以将这里的deploy_key.pub内容修改，
        # 然后重新build，但不建议这么做。

2. 环境变量

        export GIT_HOSTNAME=gitlab.XXXXXX

        # mark this for skip init project to gitlab,default is false
        export GIT_INIT_SKIP=true
        # mark this for internal gitlab, when local don't mark this will use 10080
        export GIT_EXTERNAL_PORT=80  default 10080

3. 启动

        docker-compose build
        docker-compose up -d


## gitlab-runner

1. 目录准备

        mkdir -p ${HOME}/gitlab-runner/home/.ssh ${HOME}/gitlab-runner/home/.m2 ${HOME}/gitlab-runner/etc
        chmod -R 777 ${HOME}/gitlab-runner

        # prepare maven nexus settings-security.xml
        # cd oss-internal/src/main/maven && cp settings-security.xml ${HOME}/gitlab-runner/home/.m2/settings-security.xml

        ${HOME}/gitlab-runner/home/.m2/settings-security.xml

2. 环境变量&启动

        export GIT_SERVICE_TOKEN={} #Generate form http://gitlab.xxxx/profile/personal_access_tokens

        docker-compose up -d
        docker exec -it oss-gitlab-runner touch /home/gitlab-runner/.ssh/config
        docker exec -it oss-gitlab-runner chmod 644 /home/gitlab-runner/.ssh/config
        docker exec -it oss-gitlab-runner chown -R gitlab-runner:gitlab-runner /home/gitlab-runner
        docker exec -it oss-gitlab-runner chmod 700 /home/gitlab-runner/.ssh
        docker-compose restart
        docker exec -it oss-gitlab-runner cat /home/gitlab-runner/.ssh/config
        docker exec -it oss-gitlab-runner ls -la /home/gitlab-runner/.ssh

3. 注册 [注意 untagged builds，check true ]


    ```
    Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
    ${INTERNAL_GIT_SERVICE}/ci,Ex: http://local-git/ci
    Please enter the gitlab-ci token for this runner:
    xxx(从 gitlab runner 页面里找)
    Please enter the gitlab-ci description for this runner:
    [oss-gitlab-runner]:oss-gitlab-runner-${ip}
    Please enter the gitlab-ci tags for this runner (comma separated):
    local-runner
    Whether to run untagged builds [true/false]:
    [false]: true
    Whether to lock Runner to current project [true/false]:
    [false]:
    Registering runner... succeeded                     runner=g7Q3K_A1
    Please enter the executor: parallels, virtualbox, shell, ssh, docker+machine, docker-ssh+machine, kubernetes, docker, docker-ssh:
    shell
    Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

    ```