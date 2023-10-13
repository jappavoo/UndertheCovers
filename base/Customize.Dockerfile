## Dockerfile for constructing the base Open Education Effort (OPE)
## container.  This container contains everything required for authoring OPE courses
## Well is should anyway ;-)

ARG FROM_REG
ARG FROM_IMAGE
ARG FROM_TAG

FROM ${FROM_REG}${FROM_IMAGE}${FROM_TAG}

USER root

# Static Customize for OPE USER ID choices
# To avoid problems with start.sh logic we do not modify user name
# FIXME: Add support for swinging home directory if you want to point to a mounted volume
# FIXME: don't know why we are setting DEFAULT_NB_UID -- leaving for some else to
# figurel out if we still need it

# Don't think we need it, the value needed for the startup scripts
# is nb_uid which we set later on
# ARG DEFAULT_NB_UID=${NB_UID}

# FIXME: I do not think we need to specify the ope specific uid and gid as ENV variables,
# just use them to set the respective NB_UID or NB_GID

ARG CUSTOMIZE_UID
ENV NB_UID=${CUSTOMIZE_UID}


ARG CUSTOMIZE_GID
ENV NB_GID=${CUSTOMIZE_GID}

ARG CUSTOMIZE_GROUP
ENV NB_GROUP=${CUSTOMIZE_GROUP}

ARG EXTRA_CHOWN
ARG CHOWN_HOME=yes
ARG CHOWN_HOME_OPTS="-R"
ARG CHOWN_EXTRA_OPTS='-R'
ARG CHOWN_EXTRA="${EXTRA_CHOWN} ${CONDA_DIR}"


# # use built in startup script to setup new user home
RUN /usr/local/bin/start.sh true; \
    echo "hardcoding $NB_USER to uid=$NB_UID and group name $NB_GROUP with gid=$NB_GID shell to /bin/bash" ; \
    usermod -s /bin/bash $NB_USER ; \
    [[ -w /etc/passwd ]] && echo "Removing write access to /etc/passwd" && chmod go-w /etc/passwd

# Done customization


USER $NB_USER


CMD  ["/bin/bash", "-c", "cd /home/jovyan ; start-notebook.sh"]
