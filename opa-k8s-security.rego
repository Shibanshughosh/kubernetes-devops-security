############### opa-k8s-security.rego ############### 
package main

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
  input.kind == "Deployment"
  not input.spec.selector.matchLabels.app
  msg := "Containers must provide app label for pod selectors"
}

# deny[msg] {
#   input.kind == "Deployment"
#   image := input.spec.template.spec.containers[_].image
#   not startswith(image, "verizon.com/")
#   msg := sprintf("image '%v' doesn't come from verizon.com repository", [image])
# }