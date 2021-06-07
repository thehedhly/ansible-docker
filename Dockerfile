FROM ubuntu:20.04
LABEL author="Hamza Hedhly"
LABEL version="Ubuntu 20.04 (Focal Fossa)"
LABEL documentation="https://github.com/senjoux"
# Supported Ansible releases: 
# - 4.0 (default)
# - 3.0
# - 2.10
# see releases https://docs.ansible.com/ansible/devel/roadmap/ansible_roadmap_index.html
ENV ANSIBLE_VERSION=4.0.0
# if none provided an "ansible" user will be created
ENV ANSIBLE_USER=ansible
# Python3-pip version
ENV PYTHON3_PIP_VERSION=20.0.2-5ubuntu1.5

RUN apt-get update --no-install-recommends -y \
    # prepare user
    && adduser $ANSIBLE_USER \
    && echo "$ANSIBLE_USER  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    # install Ansible
    && apt-get install --no-install-recommends python3-pip=$PYTHON3_PIP_VERSION -y \
    && rm -rf /var/lib/apt/lists/*\
    && python3.8 -m pip install --no-cache-dir ansible==$ANSIBLE_VERSION \
    # other
    && echo "export PS1='[\u@\h:\w] $ '" >> /home/$ANSIBLE_USER/.bashrc \
    # self
    && ansible --version \
    && python3.8 -m pip list

ENTRYPOINT ["/bin/bash","-c"]
CMD ["su $ANSIBLE_USER"]