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

# Install wget, bash, and make bash the default command
RUN sudo apt-get update && sudo apt-get install -y wget && sudo apt-get install -y bash

# Set up environment variables
ENV PATH="/home/${LDAP_USERNAME}/miniconda3/bin:$PATH"

CMD ["bash"]
