# Base jenkins image
FROM jenkins/jenkins:lts

# Switch to Root user
USER root

# Install more application
RUN apt-get update && apt-get install -y \
	wget \
	curl \
	python3 python3-dev python3-venv \
	maven

# Install kubectl 
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install GCLOUD
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y \ 
	google-cloud-cli \
	google-cloud-sdk-gke-gcloud-auth-plugin


# Install jenkins the plugin
#COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugins blueocean

# Install Docker-CLI
RUN curl -sSL https://get.docker.com/ | sh

# Revert back to jenkins user
USER jenkins
