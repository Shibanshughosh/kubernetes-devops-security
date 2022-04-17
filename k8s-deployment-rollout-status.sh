############### k8s-deployment-rollout-status.sh ###############
#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 60s
echo "create deployment log file"
kubectl describe deploy devsecops -n default >> deploy-failure-${commitId}.txt
echo "log file created"

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]]; 
then     
	echo "Deployment ${deploymentName} Rollout has Failed"
    kubectl -n default rollout undo deploy ${deploymentName}
    exit 1;
else
	echo "Deployment ${deploymentName} Rollout is Success"
    rm deploy-failure-${commitId}.txt
    echo "log file deleted"
fi
############### k8s-deployment-rollout-status.sh ###############


############Another Logic - Try Later###########################################

# while true; do
#     sleep 60
#     deployments=$(kubectl get deployments --no-headers -o custom-columns=":metadata.name" | grep -v "deployment-checker")
#     echo "====== $(date) ======"
#     for deployment in ${deployments}; do
#         if ! kubectl rollout status deployment ${deployment} --timeout=10s 1>/dev/null 2>&1; then
#             echo "Error: ${deployment} - rolling back!"
#             kubectl rollout undo deployment ${deployment}
#         else
#             echo "Ok: ${deployment}"
#         fi
#     done
# done


######################################################################


