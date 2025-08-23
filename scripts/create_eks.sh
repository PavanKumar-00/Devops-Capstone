#!/bin/bash
set -euo pipefail
CLUSTER_NAME=${CLUSTER_NAME:-capstone-eks}
REGION=${REGION:-ap-south-1}
NODE_TYPE=${NODE_TYPE:-t3.medium}
NODES=${NODES:-2}

eksctl create cluster --name "$CLUSTER_NAME" --region "$REGION"   --nodegroup-name ng-1 --node-type "$NODE_TYPE" --nodes "$NODES" --managed
