
# gitlab-runner

## Start and register a runner

1. GIT_SERVICE_TOKEN

OSS's ci script need the GIT_SERVICE_TOKEN to access script or configuration in internal or private repository.

- There are 2 ways to get GIT_SERVICE_TOKEN:

  1. From git service page (e.g. gitlab: http(s)://gitlab.local/profile/personal_access_tokens page).
  2. From cli (e.g. gitlab: `curl --request POST <host:port>/api/v3/session?login=<email>&password=<password>`).

- GIT_SERVICE_TOKEN need to be set before container start by `export GIT_SERVICE_TOKEN=<your_git_service_token>`.

2. Prepare directories and files
```
sudo chmod a+rw /var/run/docker.sock
mkdir -p ${HOME}/gitlab-runner/home/.ssh ${HOME}/gitlab-runner/home/.m2 ${HOME}/gitlab-runner/home/.docker ${HOME}/gitlab-runner/etc
chmod -R 777 ${HOME}/gitlab-runner
```
Gitlab cant distribute settings and keys, need to mount or download manually (e.g. maven's ~/.m2/settings-security.xml or git deploy key).

3. Execute `docker-compose up -d`

4. Find token for runner.
Shared: Goto admin/runners page (e.g. http(s)://gitlab.local/admin/runners).
Specific: Goto repo's settings/ci_cd page (e.g. http(s)://gitlab.local/<namespace>/<repo>/settings/ci_cd).

5. Execute `docker exec -it oss-gitlab-runner gitlab-runner register` and input following info (in <>).
```
Please enter the gitlab-ci token for this runner:
<Token found in step 1>
Please enter the gitlab-ci description for this runner:
<oss-gitlab-runner-<ip>>
Please enter the gitlab-ci tags for this runner (comma separated):
<oss-gitlab-runner>
Whether to run untagged builds [true/false]:
<true>
Whether to lock Runner to current project [true/false]:
<false>
Registering runner... succeeded runner=********
Please enter the executor: parallels, virtualbox, shell, ssh, docker+machine, docker-ssh+machine, kubernetes, docker, docker-ssh:
<shell>
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

## Advanced configuration (config.toml)
Use `CONFIG_FILE` environment variable specify a configuration file.
[Official doc for config.toml](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

## Note
- Container instance needs to access docker (/var/run/docker.sock) on host.
```
sudo chmod a+rw /var/run/docker.sock
```

- When register a runner "Whether to run untagged builds" should be true.

- You can inspect container by:
```
docker exec -it oss-gitlab-runner cat /home/gitlab-runner/.ssh/config
docker exec -it oss-gitlab-runner ls -la /home/gitlab-runner/.ssh
docker exec -it oss-gitlab-runner ls -la /home/gitlab-runner/.docker
```
