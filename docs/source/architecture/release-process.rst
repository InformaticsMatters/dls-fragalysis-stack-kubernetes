###############
Release process
###############

The **backend** is the source of the Django application that forms the *base image*
of the **stack**. The by-product of a backend build is a container image
pushed to Docker hub and it is this image that is the ``FROM`` image used
by the stack's ``Dockerfile``.

***************************
Releasing stacks to staging
***************************
Whenever the ``staging`` or ``production`` branch of the **backend** is built
it triggers a build of the **stack**, producing a stack image labelled ``latest``.
These ``latest`` images are manually deployed to the designated Kubernetes
namespace using a production cluster AWX Job Template.

.. epigraph::

    You *normally* do not need to build the stack, a ``latest`` version should
    have been built automatically from the most recent activity in either the
    **frontend** or **backed**.

When done deploy the stack using the appropriate AWX **Job Template**,
this is likely to be the template **Staging Fragalysis Stack (Version Change)**.
The ``stack_image_tag`` should already be set to ``latest``, the image
just built.

.. epigraph::

    An expert user could also simply delete the corresponding **Pod**
    (in the `staging-stack` **Namespace**) which will force Kubernetes to pull
    the new (``latest``) container image before starting running it.

******************************
Releasing stacks to production
******************************

When you want to build a **stack** for **production** (which will be
deployed automatically to the ``production-stack`` **Namespace** of the
production Kubernetes cluster) you **MUST**: -

#.  Decide which **backend** and **frontend** versions should be used for the
    new stack image
#.  Using the chosen versions edit (and then commit) the stack repository's
    ``.github/workflows/build-main.yaml`` file: -

    #.  Replace the value of the ``env`` variable ``BE_IMAGE_TAG``
        with your chosen version of the backend container image
    #.  Replace the ``FE_BRANCH`` with your chosen version of the
        frontend code (the variable is a GitHub *reference* and can
        be a set to a tag as well as a branch name)

#.  Tag the stack repository with your chosen **stack** tag.

    #.  The preferred style of tags is ``YEAR.MONTH.ITERATION``, i.e.
        ``2023.06.1`` for the first release in June 2023. The month
        is a 2-digit value with a leading zero if necessary.

Example
*******
To deploy a new production **stack** version ``2023.06.2`` based
on **backend** ``2023.05.1`` and **frontend** ``2023.05.4`` set the
workflow file variables to this::

    BE_IMAGE_TAG: 2023.05.1
    FE_BRANCH: 2023.05.4

Commit the change and then (when the build passes) tag the stack repository's
``master`` branch with the value ``2023.06.2``.

The **stack** GitHub Action will ensure the new  build is automatically
deployed to the ``production-stack`` **Namespace** of the production Kubernetes
cluster (using the Action's **deploy-production** job step).

.. epigraph::

    The repository tags **MUST** be a 3-digit `Semantic Versioning`_
    value, i.e. ``2023.06.2``. If it is not the stack will be built
    but it will not be deployed.

.. _semantic versioning: https://semver.org
