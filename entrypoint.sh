#!/bin/sh
# entrypoint.sh

# Function to run on receiving SIGTERM or SIGINT
cleanup() {
    echo "-----------------------------------------------------"
    echo " Received termination signal. Cleaning up..."
    echo "-----------------------------------------------------"
    # Add any cleanup commands here, e.g.:
    # sync # Ensure disk writes are flushed
    # kill $child_pid # If you were managing a background process
    exit 0 # Exit gracefully
}

# Trap SIGTERM (signal 15) and SIGINT (signal 2) and call the cleanup function
trap cleanup TERM INT

echo "-----------------------------------------------------"
echo " K8s Toolbox Container Starting Up"
echo "-----------------------------------------------------"
# ... (rest of your startup logs) ...
echo "-----------------------------------------------------"
echo ""
echo "Executing command: $@"
echo "PID: $$" # Print the PID of the script itself
echo ""

# Execute the command passed as arguments (from CMD or docker run)
# IMPORTANT: Using 'exec' replaces the script process.
# The trap defined above will NOT handle signals sent *after* exec runs,
# unless the executed command ($@) handles them itself.
# If you need the script to wait and handle signals while the command runs,
# you would run the command in the background and use 'wait'.
exec "$@"

# --- Alternative: Run command in background and wait (allows script to handle signals) ---
# "$@" & # Run command in the background
# child_pid=$! # Get the PID of the background command
# echo "Waiting for command (PID: $child_pid) to finish..."
# wait $child_pid # Wait for the background command to exit
# echo "Command finished."
# exit $? # Exit with the command's exit code
# ---------------------------------------------------------------------------------------
