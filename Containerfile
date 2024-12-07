# Extend from quay.io/podman/stable
FROM quay.io/podman/stable

# Install dependencies and Jenkins
RUN dnf install -y \
    wget \
    java-21-openjdk-devel \
    sudo \
    curl \
    git \
    dnf-plugins-core \
    && wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo \
    && rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key \
    && dnf install fontconfig -y \
    && dnf install -y jenkins \
    && dnf clean all

USER root

# Allow jenkins user to use sudo to switch to podman user without password
RUN echo 'jenkins ALL=(podman) NOPASSWD:ALL' >> /etc/sudoers

# Ensure Jenkins home directory is created with the correct permissions as root
RUN mkdir -p /var/jenkins_home && \
    chown -R jenkins:jenkins /var/jenkins_home

# Set environment variables for Jenkins
ENV JENKINS_HOME=/var/jenkins_home

# Switch to the jenkins user
USER jenkins

# Add podman alias
RUN echo "alias podman='sudo -u podman podman'" >> ~/.bashrc && \
    source ~/.bashrc

# Expose Jenkins port
EXPOSE 8080

# Set entrypoint to start Jenkins
ENTRYPOINT ["jenkins"]
