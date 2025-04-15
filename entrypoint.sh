#!/bin/sh
# entrypoint.sh

echo "-----------------------------------------------------"
echo " K8s Toolbox Container Starting Up"
echo "-----------------------------------------------------"
echo "Purpose: Provides common networking and Kubernetes"
echo "         troubleshooting tools (kubectl, tcpdump,"
echo "         iproute2, net-tools, curl, wget, bind-tools,"
echo "         mtr, httpie)."
echo ""
echo "Current Configuration: Container will sleep for 6 hours."
echo "                     (Command: sleep 6h)"
echo ""
echo "To use interactively:"
echo " - Override the command: 'docker run -it --rm <image_name> /bin/sh'"
echo " - Or exec into running container: 'docker exec -it <container_id_or_name> /bin/sh'"
echo "-----------------------------------------------------"
echo ""
echo "Executing command: $@"
echo ""

# Execute the command passed as arguments (from CMD or docker run)
exec "$@"
