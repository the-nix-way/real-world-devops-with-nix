#!/bin/bash

echo "Building container using Nix..."

nix build ".#docker"

echo "Logging into Docker Hub..."

echo "${DOCKER_ACCESS_TOKEN}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

echo "Loading Docker image..."

docker load < result

TAG=$(docker load < result | grep -Po 'Loaded image: \K.*')
echo "Pushing ${TAG} image..."

docker push "${TAG}"

echo "Switching to minikube context..."
kubectx minikube

echo "Setting the deployment to use the ${TAG} image..."
kubectl set image deployment.apps/todos-deployment todos="${TAG}"

echo "Restarting the deployment..."
kubectl rollout restart deployment.apps/todos-deployment

NEW_IMAGE=$(kubectl get deployments.apps/todos-deployment --output=json | jq '.spec.template.spec.containers[0].image')
echo "Now running new image ${NEW_IMAGE}"
