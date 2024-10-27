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

# Set up user environment
USER ${LDAP_USERNAME}
WORKDIR /home/${LDAP_USERNAME}/Protein-design-rcp

# Copy everything to the container
COPY . .

# Set up environment variables and path for using Miniconda
ENV PATH="/home/${LDAP_USERNAME}/Protein-design-rcp/miniconda3/bin:$PATH"

# Install dependencies and set up the environment using setup.sh
RUN chmod +x setup.sh && ./setup.sh

# Default command for the Docker container
CMD ["bash"]
