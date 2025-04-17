#!/bin/bash
set -euo pipefail

ENCLAVE=""
MAX_RETRIES=5
RETRY_DELAY=5

while [[ $# -gt 0 ]]; do
    case $1 in
        --enclave)
            ENCLAVE="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$ENCLAVE" ]]; then
    echo "Error: --enclave argument is required"
    exit 1
fi

check_logs() {
    local service=$1
    echo "Checking logs for $service..."
    
    for ((i=1; i<=$MAX_RETRIES; i++)); do
        if logs=$(kurtosis service logs "$ENCLAVE" "$service" 2>&1); then
            # Filter out Kurtosis RPC errors
            filtered_logs=$(echo "$logs" | grep -v "rpc error: code = Unknown desc")
            
            if echo "$filtered_logs" | grep -iE "crit|error" > /dev/null; then
                echo "Found critical/error logs in $service (attempt $i):"
                echo "$filtered_logs" | grep -iE "crit|error"
                return 1
            else
                echo "No critical/error logs found in $service"
                return 0
            fi
        else
            echo "Failed to get logs for $service (attempt $i of $MAX_RETRIES)"
            if [ $i -lt $MAX_RETRIES ]; then
                echo "Retrying in $RETRY_DELAY seconds..."
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    echo "Failed to get logs after $MAX_RETRIES attempts"
    return 1
}

errors=0

# Check proposer logs
if ! check_logs "op-succinct-proposer-001"; then
    errors=$((errors + 1))
fi

# Check server logs
if ! check_logs "op-succinct-server-001"; then
    errors=$((errors + 1))
fi

if [ $errors -gt 0 ]; then
    echo "Found errors in service logs"
    exit 1
fi

echo "All services logs clear of critical/error messages"
exit 0