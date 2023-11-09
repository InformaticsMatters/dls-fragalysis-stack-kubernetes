################
Building locally
################

As a short-cut to development you can build your image locally, push it to Docker Hub
and then run the appropriate AWX *Version Change* playbook to deploy it to the
Developer Cluster.

With clones of the appropriate repository/branch you can build and push a stck image
with the following commands: -

In the ``fragalysis-backend`` repository build a backend image
(this does not have to be pushed to Docker Hub), run the following, using your own
values for ``BE_NAMESPACE`` and ``BE_IMAGE_TAG``::

    export BE_NAMESPACE=alanbchristie
    docker build . -t ${BE_NAMESPACE}/fragalysis-backend:latest

Then, from within the ``fragalysis-stack`` clone, run::

    export BE_NAMESPACE=alanbchristie
    export BE_IMAGE_TAG=latest
    export FE_NAMESPACE=xchem
    export FE_IMAGE_TAG=staging
    export STACK_NAMESPACE=alanbchristie
    export STACK_IMAGE_TAG=latest
    docker build . --no-cache -t ${STACK_NAMESPACE}/fragalysis-stack:${STACK_IMAGE_TAG} \
        --build-arg BE_NAMESPACE=${BE_NAMESPACE} \
        --build-arg BE_IMAGE_TAG=${BE_IMAGE_TAG} \
        --build-arg FE_NAMESPACE=${FE_NAMESPACE} \
        --build-arg FE_IMAGE_TAG=${FE_IMAGE_TAG}

Again, choosing your own values for the various variables.

With this done you'll have a local image.

Push it to Docker Hub with::

    docker push ${STACK_NAMESPACE}/fragalysis-stack:${STACK_IMAGE_TAG}

Once pushed you can then run your AWX *Version Change* playbook **Template**
to deploy the new image to your stack in the Developer Cluster.
