#!/bin/bash
set -e

# decode gcloud key from env variable to file
echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/gcloud-service-key.json
# authenticate with service account + setup docker credentials
gcloud --quiet auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
gcloud --quiet auth configure-docker

# tag image for registry
docker tag ${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:latest gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT
# push image to registry
docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}

# add "latest" tag to image
gcloud --quiet container images add-tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:latest
