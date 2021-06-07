<img src="README-Resources/ansible_logo_icon.png" width="150" height="150" alt="Ansible Logo" />

# Docker-Ansible
[![CI][badge-gh-actions]][link-gh-actions]

## Features
- Ansible control Docker image.
- Custom Ubuntu user creation

## OS support
| OS | Version |
|------|---------|
| Ubuntu | 20.04 (Focal Fossa) |

## Ansible releases support:
| Release |
|------|
| 4.0 |
| 3.0 |
| 2.10 |

## Environment variables

| Name | Version | default |
|------|---------|---------|
| `ANSIBLE_VERSION` | Ansible version. | 4.0.0 |
| `ANSIBLE_USER` | Custom Ubuntu user name. | ansible |
| `PYTHON3_PIP_VERSION` | Version of the "python3-pip" module to be used for Ansible installation. | 20.0.2-5ubuntu1.5 |

## Usage
- Build image
```
docker build -t ansible_control:<ansible_version> .
```
- Run & access container
```
docker build -t ansible_control:<ansible_version> .
```


This project was created by [Hamza Hedhly](https://de.linkedin.com/in/hedhly).

[badge-gh-actions]: https://github.com/senjoux/docker_ansible/actions/workflows/release.yml/badge.svg
[link-gh-actions]: https://github.com/senjoux/docker_ansible/actions/workflows/release.yml