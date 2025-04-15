FROM alpine:3.21.3

# Update the package list and install necessary dependencies
RUN apk update && apk add --no-cache tcpdump iproute2 net-tools curl wget bind-tools mtr httpie

# Download the latest stable release of kubectl
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# Verify the binary (optional but recommended)
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c -

# Install kubectl
RUN chmod +x kubectl && mv kubectl /usr/local/bin/

# Clean up
RUN rm kubectl.sha256

# Verify the installation
RUN kubectl version --client

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command: Start container in sleep mode for 6 hours
# This command will be passed as arguments to the ENTRYPOINT script
CMD ["sleep", "6h"]
