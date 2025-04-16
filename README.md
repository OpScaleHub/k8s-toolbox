## Running k8s-toolbox in Kubernetes

You can easily run the `k8s-toolbox` image directly within your Kubernetes cluster using `kubectl` for debugging, maintenance, or testing purposes. This avoids the need to build or install tools locally or onto cluster nodes.

**Prerequisites:**

*   `kubectl` installed and configured to access your Kubernetes cluster.

### Method 1: Using `kubectl run` (Simple Interactive Shell)

This is the most straightforward way to get an interactive shell inside the `k8s-toolbox` container running as a temporary pod in your cluster.

1.  **Run the container interactively:**

    ```bash
    kubectl run k8s-toolbox --rm -it --image=ghcr.io/opscalehub/k8s-toolbox:main -- sh
    ```

    *   `kubectl run k8s-toolbox`: Creates a temporary pod named `k8s-toolbox`.
    *   `--rm`: Automatically removes the pod when you exit the shell.
    *   `-it`: Allocates a pseudo-TTY and keeps stdin open, allowing you to interact with the shell.
    *   `--image=ghcr.io/opscalehub/k8s-toolbox:main`: Specifies the official image to use.
    *   `-- sh`: Overrides the default container command and starts a shell (`sh`). You can also use `/bin/bash` if you prefer bash features.

2.  **Use the tools:** Once the command executes successfully, you'll have a shell prompt (`#` or `$`) inside the container running within your cluster's default namespace. You can now use tools like `curl`, `dig`, `netcat`, `ip`, `ping`, `traceroute`, `kubectl` (if configured/needed with a service account), etc.

    ```bash
    # Example: Check connectivity to a service
    curl http://my-service.my-namespace.svc.cluster.local:8080

    # Example: Perform DNS lookup
    dig my-service.my-namespace.svc.cluster.local

    # Example: Check network interfaces
    ip addr
    ```

3.  **Exit:** Type `exit` and press Enter. The container and the temporary pod will be automatically cleaned up because of the `--rm` flag.

**Variations:**

*   **Run in a specific namespace:** Add the `-n <namespace>` flag:
    ```bash
    kubectl run k8s-toolbox-debug --rm -it -n my-namespace \
      --image=ghcr.io/opscalehub/k8s-toolbox:main -- sh
    ```
*   **Run with a specific service account (for API access):** Add the `--serviceaccount=<service-account-name>` flag (ensure the service account exists and has necessary permissions):
    ```bash
    kubectl run k8s-toolbox-debug --rm -it \
      --image=ghcr.io/opscalehub/k8s-toolbox:main \
      --serviceaccount=my-debug-sa -- sh
    ```

### Method 2: Using `kubectl debug` (Advanced Debugging)

`kubectl debug` provides more advanced debugging capabilities, such as attaching to existing pods or nodes.

1.  **Debug a Node:** Run the toolbox pod directly on a specific node, potentially with host privileges (use with caution).

    ```bash
    kubectl debug node/<node-name> -it --image=ghcr.io/opscalehub/k8s-toolbox:main
    ```
    This creates a pod on the specified node, often mounting host namespaces, allowing you to inspect node-level resources or network configuration.

2.  **Debug a Running Pod (Ephemeral Container):** Attach the toolbox as an ephemeral debug container to an *existing* pod without restarting it (requires Kubernetes v1.23+ and `EphemeralContainers` feature gate enabled, default in v1.25+).

    ```bash
    kubectl debug -it <pod-name> -n <namespace> \
      --image=ghcr.io/opscalehub/k8s-toolbox:main \
      --target=<container-name-in-pod> -- sh
    ```
    *   `--target`: (Optional) If the pod has multiple containers, specify which one to share process namespaces with.

3.  **Debug a Pod (Copy):** Create a copy of an existing pod with the toolbox image replacing or added to the original containers.

    ```bash
    kubectl debug <pod-name> -n <namespace> --copy-to k8s-toolbox-debug-copy \
      -it --image=ghcr.io/opscalehub/k8s-toolbox:main -- sh
    ```
    This creates a new pod (`k8s-toolbox-debug-copy`) based on the original pod's spec but running the toolbox image, useful for inspecting volumes or configuration without affecting the original pod.

Choose the method that best suits your debugging needs. For general-purpose network testing or tool access within the cluster, `kubectl run` is often the simplest starting point.
