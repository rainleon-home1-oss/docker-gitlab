
1. 宿主机目录

    mkdir -p ${HOME}/data/gitlab/config && mkdir -p ${HOME}/data/gitlab/data && mkdir -p ${HOME}/data/gitlab/logs

    # 注意，gitlab/docker/deploy_key.pub 用来向gitlab添加configserver应用的ssh key，这里默认会添加一组公私钥:
    # 如果有新的需求需要添加新的可以通过web界面：http://gitlab.XXXXX/group_name/repo_name/settings/repository: Deploy Keys 添加，当然也可以将这里的deploy_key.pub内容修改，
    # 然后重新build，但不建议这么做。

2. 环境变量

    export GIT_HOSTNAME=gitlab.XXXXXX

    # mark this for skip init project to gitlab,default is true,this will work only after init at least once
    export GIT_INIT_SKIP=true
    # mark this for internal gitlab, when local don't mark this will use 10080
    export GIT_EXTERNAL_PORT=80  default 10080
    # modify this to refer another deploy_key file, make sure the file exists,ex:
    # locate file at host path: ${HOME}/data/gitlab/config/deploy_key.pub
    # as in container the location is /etc/gitlab/deploy_key.pub,so export GIT_DEPLOY_KEY:
    export GIT_DEPLOY_KEY=/etc/gitlab/deploy_key.pub

3. 启动

    docker-compose build
    docker-compose up -d
