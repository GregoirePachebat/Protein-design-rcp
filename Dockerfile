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
WORKDIR /home/${LDAP_USERNAME}/Protein-design-rcp

# Copy everything to the container
COPY . .

# Set permissions for setup.sh and run it as root
RUN chmod +x setup.sh && ./setup.sh

# Switch to the user to run commands as them
USER ${LDAP_USERNAME}

# Set up environment variables and path for using Miniconda
ENV PATH="/home/${LDAP_USERNAME}/miniconda3/bin:$PATH"

# Default command for the Docker container
CMD ["bash"]
