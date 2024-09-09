#compdef kubens kns=kubens kubectl-ns
_arguments "1: :(- $(kubectl get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}'))"
