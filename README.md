# ansible-docker

![Build](https://github.com/thehedhly/ansible-docker/actions/workflows/ci.yml/badge.svg?branch=dev)
![Docker build](https://github.com/thehedhly/ansible-docker/actions/workflows/linter.yml/badge.svg?branch=dev)

<img src="README-Resources/ansible_logo_icon.png" width="100" height="100" alt="Ansible Logo" />

## Features
- Builds [python](https://hub.docker.com/_/python) based __ansible-core__ and __ansible community package__ docker __images__.

## Ansible:
In accordance with both ansible community projects, __ansible community package__ and __ansible-core__, this project builds two seperate images as follows:

| Ansible project | Supported versions | DockerHub Image |
|-----------------|----------|-------|
| ansible community package | <ul><li>9.0</li><li>10.0</li></ul> | [thehedhly/ansible](https://hub.docker.com/repository/docker/thehedhly/ansible) |
| ansible-core | <ul><li>2.16</li><li>2.17</li></ul> | [thehedhly/ansible-core](https://hub.docker.com/repository/docker/thehedhly/ansible-core) |

## Build arguments
| Name | description | default |
|------|---------|---------|
| `BASE_IMAGE` | Base docker image. | python:3.11.7-slim |
| `PYCMD` | Python binary location.<br>:information_source: See also `BASE_IMAGE` | /usr/local/bin/python3.11 |
| `SYS_ZONEINFO` | System time zone. | Europe/Berlin |
| `ANSIBLE_INSTALL_REFS` | Ansible installation package.<br>You can install a specific version of a ansible community package or ansible-core, e.g.:<br><ul><li>ansible-core==2.16.0</li>or<li>ansible==9</li></ul> | ansible-core |
| `ANSIBLE_HOME` | Ansible home where the build's extra (optional) ansible roles/collections are installed.<br>See [Ansible requirements.yml](requirements.yml) | /usr/share/ansible |
| `ANSIBLE_GALAXY_CLI_COLLECTION_OPTS` | Build's CLI options for installing ansible collection.<br>Check [ansible-galaxy]() cli documentation for more details.| -v |
| `ANSIBLE_GALAXY_CLI_ROLE_OPTS` | Build's CLI options for installing ansible roles.<br>Check [ansible-galaxy]() cli documentation for more details. | -v |
| `ANSIBLE_USER` | User to set for ansible image. A home directory is setup for the provided user. The default [ansible configuration file](ansible.cfg) for the user is located in his home driectory. | thehedhly |


## Usage
### Build
`ansible-core`
```
docker build -t ansible-core .
```
```
docker build --build-arg ANSIBLE_INSTALL_REFS=ansible-core==<version> -t ansible-core:<tag> .
```
`ansible community package`
```
docker build --build-arg ANSIBLE_INSTALL_REFS=ansible -t ansible .
```
```
docker build --build-arg ANSIBLE_INSTALL_REFS=ansible==<version> -t ansible:<tag> .
```
#### Run
`ansible-core`
```
docker run --rm -it ansible-core bash
```
```
docker run --rm -it ansible-core:<tag> bash
```
```
docker run --rm -it --mount type=bind,source=/home/<username>/<ansible-project-name>,target=/opt/<ansible-project-name> --mount type=bind,source=/home/<username>/.ssh,target=/home/<username>/.ssh,readonly <ansible-core| ansible-core:<tag>> bash
```
`ansible community package`
```
docker run --rm -it ansible bash
```
```
docker run --rm -it ansible:<tag> bash
```
```
docker run --rm -it --mount type=bind,source=/home/<username>/<ansible-project-name>,target=/opt/<ansible-project-name> --mount type=bind,source=/home/<username>/.ssh,target=/home/<username>/.ssh,readonly <ansible| ansible:<tag>> bash
```

This project was created by [H.Hedhly](https://hedhly.com).
