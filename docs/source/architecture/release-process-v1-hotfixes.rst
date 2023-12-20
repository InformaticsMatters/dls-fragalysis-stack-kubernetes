###############################
Release process (V1 hot-fixing)
###############################

To release a patch (hot-fix) to the V1 production stack, which is no longer driven
by the automated CI process, you will need to first create branches on the underlying
repositories, change the code and tag it before tagging the ``v1-hotfix`` branch of the
Fragalysis Stack repository.

******************
Hot-fixing the f/e
******************

A branch for the most recent official front-end already exists: - ``2023.11.1-v1-hotfix-1``.
Reuse this branch for all V1 hot-fixes as required.

.. epigraph::

    FYou can create a branch from a tag in GitHub using the command
    ``git checkout -b 2023.11.1-v1-hotfix-1 2023.11.1``. That example will create the
    branch ``2023.11.1-v1-hotfix-1`` from the tag ``2023.11.1``

- Make front-end changes to that branch and then tag it (eg. ``2023.11.1-1``)
- Place that tag in the stack's ``build-main.yaml`` file (on its ``v1-hotfix`` branch)
- Commit the changes
- Tag the stack's ``v1-hotfix`` branch with a new tag (e.g. ``2023.11.1-1``)

The resultant stack image will be pushed to docker hub.

Now follow the instructions below in `Deploying a hot-fix`_.

.. warning::
    To avoid confusion the tag for V1 hot-fixes on the f/e, backend and stack repositories
    **MUST** begin with the tag used for the last formal production release form that
    repository. For the f/e is is ``2023.11.1``. For the b/e it is ``2023.09.1`` and for
    the stack it is ``2023.11.1``.

******************
Hot-fixing the b/e
******************

A branch for the most recent official front-end already exists: - ``2023.09.1-v1-hotfix-1``.
Reuse this branch for all V1 hot-fixes as required.

- Make back-end changes to that branch and then tag it (eg. ``2023.09.1-1``)
- Place that tag in the stack's ``build-main.yaml`` file (on its ``v1-hotfix`` branch)
- Commit the changes to the stack repository
- Tag the stack's ``v1-hotfix`` branch with a new tag (e.g. ``2023.11.1-2``)

The resultant stack image will be pushed to docker hub.

.. warning::
    To avoid confusion the tag for V1 hot-fixes on the f/e, backend and stack repositories
    **MUST** begin with the tag used for the last formal production release form that
    repository. For the f/e is is ``2023.11.1``. For the b/e it is ``2023.09.1`` and for
    the stack it is ``2023.11.1``.

Now follow the instructions below in `Deploying a hot-fix`_.

*******************
Deploying a hot-fix
*******************

-   Verify the expected stack image is on DockerHub
-   Navigate (using lens or k9s) to the ``production-stack`` *Namespace* in the
    production kubernetes cluster
-   Edit the ``stack`` **StatefulSet**, replacing the *container* *image*value with the
    recently built stack and hot-fix tag (e.g. ``docker.io/xchem/fragalysis-stack:2023.11.1-1``)
-   Save the **StatefulSet** in order for the new image to be deployed.
-   Check the stack's Pod deployment
