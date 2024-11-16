# Base image with GPU support
FROM nvcr.io/nvidia/pytorch:23.11-py3


# Set arguments for LDAP user information to handle permissions
ARG LDAP_USERNAME
ARG LDAP_UID
ARG LDAP_GROUPNAME
ARG LDAP_GID

# Create a group and user inside the container
RUN groupadd ${LDAP_GROUPNAME} --gid ${LDAP_GID} && \
    useradd -m -s /bin/bash -g ${LDAP_GROUPNAME} -u ${LDAP_UID} ${LDAP_USERNAME}

# Switch to the new user and set up the environment
USER ${LDAP_USERNAME}
WORKDIR /home/${LDAP_USERNAME}

# Ensure non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Clean and update the system, then install dependencie

COPY --chown=${LDAP_USERNAME}:${LDAP_GROUPNAME} pipeline_code /app/pipeline_code
COPY --chown=${LDAP_USERNAME}:${LDAP_GROUPNAME} setup.sh /app/setup.sh
COPY --chown=${LDAP_USERNAME}:${LDAP_GROUPNAME} run.sh /app/run.sh
COPY config.yaml /app/config.yaml

RUN chmod +x /app/run.sh
RUN chmod +x /app/setup.sh

WORKDIR /app



CMD ["/app/run.sh"]
