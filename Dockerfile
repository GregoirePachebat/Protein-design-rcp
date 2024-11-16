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

# Clean and update the system, then install dependencies
RUN rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/apt/lists/partial \
    && chmod -R 755 /var/lib/apt/lists/ \
    && apt-get update \
    && apt-get install -y wget bash \
    && rm -rf /var/lib/apt/lists/*


# Set up environment variables
ENV PATH="/home/${LDAP_USERNAME}/miniconda3/bin:$PATH"


#copy the app in the container
COPY pipeline_code /app/pipeline_code
COPY setup.sh /app/setup.sh
COPY run.sh /app/run.sh
COPY config.yaml /app/config.yaml

WORKDIR /app

RUN chmod +x /app/run.sh

CMD ["/app/run.sh"]
