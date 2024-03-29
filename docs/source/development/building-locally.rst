################
Building locally
################

As a short-cut to development you can build your image locally, push it to Docker Hub
and then run the appropriate AWX *Version Change* playbook to deploy it to the
Developer Cluster.

A full build relies on a backend container image, frontend container image and the
stack image that combines the two. You m ay n ot need to build the frontend or backend,
that's a decision you have to make.

You will need: -

- `poetry`_ (for the backend build)
- `docker`_

With clones of the appropriate repository/branch you can build and push a stack image
with the following commands: -

In the ``fragalysis-backend`` repository, where we typically have ``staging`` and ``production``
branches, build your backend image (this does not have to be pushed to Docker Hub),
by running the following, using your own values for ``BE_NAMESPACE`` and ``BE_IMAGE_TAG``::

    export BE_NAMESPACE=alanbchristie
    export BE_IMAGE_TAG=latest
    poetry export --without-hashes --without dev --output requirements.txt
    docker build . -t ${BE_NAMESPACE}/fragalysis-backend:${BE_IMAGE_TAG}

In the ``fragalysis-frontend`` repository, where we also have ``staging`` and ``production``
branches, build a frontend image (this does not have to be pushed to Docker Hub),
by running the following, using your own values for ``FE_NAMESPACE`` and ``FE_IMAGE_TAG``::

    export FE_NAMESPACE=alanbchristie
    export FE_IMAGE_TAG=latest
    docker build . -t ${FE_NAMESPACE}/fragalysis-frontend:${FE_IMAGE_TAG}

Then, from within the ``fragalysis-stack`` clone, combine your backend and frontend
images. The ``fragalysis-stack`` repo traditionally only has a ``master`` branch::

    export BE_NAMESPACE=alanbchristie
    export BE_IMAGE_TAG=latest
    export FE_NAMESPACE=alanbchristie
    export FE_IMAGE_TAG=latest
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

Once pushed you can then run your chosen AWX playbook **Job Template**
to deploy the new image to your stack in the Developer Cluster.

.. _poetry: https://python-poetry.org/
.. _docker: https://www.docker.com/
