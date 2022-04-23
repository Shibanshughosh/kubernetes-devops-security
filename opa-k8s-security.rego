############### opa-k8s-security.rego ############### 
package main
#package kubernetes.admission

import data.kubernetes.networkpolicies

# Deny with a message
# deny[msg]{
#   ensure
#   count(input.request.object.spec.ingress)
#   msg:= sprintf("The Network Policy: %v could not be created because it violates the proprietary app security policy.",[input.request.object.metadata.name])
# }

# ensure {
#   # When the requested object is a NetworkPolicy
#   input.request.kind.kind == "NetworkPolicy"
#   # and it is controlling our protected pods (those labelled app=prop)
#   input.request.object.spec.podSelector.matchLabels["app"] == "devsecops"
#   # get the pod label values when they key is "app" from the list of labels that this policy controlls ingress connections to
#   values := {v["app"] | v:= input.request.object.spec.ingress[_].from[_].podSelector.matchLabels}
#   # if we do not have "app=frontend" as the allowed value, this policy is violated
#   not exists(values,"frontend") # false because we have frontend
# }

# # A hepler function to test the eixstence of the label value
# exists(arr,elem) {
#   arr[_] == elem
# }

# ensure {
#   # Ensure that we only have one policy in the ingress
#    1 != count(input.request.object.spec.ingress) # false because we have just one ingress
#  }

# ensure {
#   # Ensure that we only have one policy in the ingress
#   1 != count([from | from := input.request.object.spec.ingress[_].from]) # should be false because we have more than one from
# }

#################################
# Deny with a message
# deny[msg]{
# 	input.request.kind.kind == "Pod"
# 	pod_label_value := {v["app"] | v := input.request.object.metadata.labels} # true
#   contains_label(pod_label_value,"devsecops")
#   np_label_value := {v["app"] | v := networkpolicies[_].spec.podSelector.matchLabels}
#   not contains_label(np_label_value,"devsecops")
# 	msg:= sprintf("The Pod: %v could not be created because it is missing an associated Network Security Policy.",[input.request.object.metadata.name])
# }
# contains_label(arr,val){
# 	arr[_] == val
# }

##############################Basic Policies#################################################

deny[msg] {
  input.kind = "Service"
  not input.spec.type = "NodePort"
  msg = "Service type should be NodePort"
}

deny[msg] {
  input.kind = "Deployment"
  not input.spec.template.spec.containers[0].securityContext.runAsNonRoot = true
  msg = "Containers must not run as root - use runAsNonRoot within container security context"
}

deny[msg] {
  input.kind = "Deployment"
  not input.spec.selector.matchLabels.app
  msg := "Containers must provide app label for pod selectors"
}

deny[msg] {
  input.kind = "NetworkPolicy"
  not input.request.object.spec.podSelector.matchLabels.app = "devsecops"
  msg := "Network policy not defined for app - devsecops"
}
# deny[msg] {
#   input.kind == "Deployment"
#   image := input.spec.template.spec.containers[_].image
#   not startswith(image, "verizon.com/")
#   msg := sprintf("image '%v' doesn't come from verizon.com repository", [image])
# }


##################################End Basic Policies###################################