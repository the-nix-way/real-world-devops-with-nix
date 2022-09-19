k8s-apply:
	kubectl apply -f ./k8s/deployment.yaml

port-forward:
	kubectl port-forward deployments.apps/todos-deployment 8080:8080

show-image:
	kubectl get deployments.apps/todos-deployment --output=json | jq '.spec.template.spec.containers[0].image'
