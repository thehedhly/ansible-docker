# Before overriding BASE_IMAGE and PYCMD, please consult:
#   - https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix
#   and also maybe (in case want to install ansible community):
#   - https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-changelogs
#
ARG BASE_IMAGE="python:3.11.7-slim"
ARG PYCMD="/usr/local/bin/python3.11"
ARG SYS_ZONEINFO="Europe/Berlin"
ARG ANSIBLE_HOME="/usr/share/ansible"
ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS="-v"
ARG ANSIBLE_GALAXY_CLI_ROLE_OPTS=""
ARG ANSIBLE_INSTALL_REFS="ansible-core==2.16.0"
# ARG ANSIBLE_INSTALL_REFS="ansible-core"
# ARG ANSIBLE_INSTALL_REFS="ansible==9"
# ARG ANSIBLE_INSTALL_REFS="ansible"
ARG ANSIBLE_USER="thehedhly"

# Base build stage
FROM $BASE_IMAGE as base
# USER root
ARG BASE_IMAGE
ARG PYCMD
ARG ANSIBLE_INSTALL_REFS

RUN unlink /etc/localtime \
    && ln -s "/usr/share/zoneinfo/$SYS_ZONEINFO" /etc/localtime \
    && "$PYCMD" -m ensurepip \
    && "$PYCMD" -m pip install --no-cache-dir "$ANSIBLE_INSTALL_REFS"
# USER guest

# Galaxy build stage
FROM base as galaxy
ARG ANSIBLE_HOME
ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS
ARG ANSIBLE_GALAXY_CLI_ROLE_OPTS
WORKDIR /
COPY requirements.yml .
RUN ansible-galaxy role install "$ANSIBLE_GALAXY_CLI_ROLE_OPTS" -r requirements.yml --roles-path "$ANSIBLE_HOME/roles"\
    && ANSIBLE_GALAXY_DISABLE_GPG_VERIFY=1 ansible-galaxy collection install "$ANSIBLE_GALAXY_CLI_COLLECTION_OPTS" -r requirements.yml --collections-path "$ANSIBLE_HOME/collections"

# Final build stage
FROM base as final
LABEL org.opencontainers.image.created="date and time on which the image was built (string, date-time as defined by RFC 3339)"
LABEL org.opencontainers.image.authors="https://github.com/thehedhly"
LABEL org.opencontainers.image.url="dockerhub url"
LABEL org.opencontainers.image.source="github repository"
LABEL org.opencontainers.image.version="version of the packaged software"
ARG ANSIBLE_HOME
ARG ANSIBLE_USER
ENV ANSIBLE_CONFIG "/home/$ANSIBLE_USER/.ansible.cfg"
# ENV ANSIBLE_HOME = $XANSIBLE_HOME

COPY --from=galaxy $ANSIBLE_HOME $ANSIBLE_HOME

RUN useradd -m "$ANSIBLE_USER"\
    && echo "$ANSIBLE_USER  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers\
    && apt-get update\
    && apt-get install --no-install-recommends -y openssh-client\
    && apt-get install --no-install-recommends -y iputils-ping\
    && apt-get -qq clean\
    && rm -rf /var/lib/apt/lists/*

USER $ANSIBLE_USER
COPY --chown="$ANSIBLE_USER:$ANSIBLE_USER" ansible.cfg "$ANSIBLE_CONFIG"

WORKDIR "/home/$ANSIBLE_USER"

# ENTRYPOINT ["/bin/bash","-c"]
# CMD ["su $ANSIBLE_USER"]
