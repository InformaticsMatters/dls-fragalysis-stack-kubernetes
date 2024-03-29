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

Whenever the ``staging`` or ``production`` branch of the **backend** (or **frontend**)
is built it triggers a build of the **stack**, producing a stack image labelled ``latest``.
These ``latest`` images are automatically deployed to the designated Kubernetes
namespace using a production cluster AWX Job Template.

.. epigraph::

    You *normally* do not need to build the stack. A ``latest`` version should
    have been built automatically from the most recent activity in either the
    **frontend** or **backed** ``staging`` branches

******************************
Releasing stacks to production
******************************

A release consists of material from three repositories (and three tags).
You must have tagged the **backend** repository, the **frontend** repository and then,
finally, the **stack** repository.

At each step described here you must check the individual repository CI/CD GitHub Action
to ensure that the action has completed successfully before moving to the next step.

Releasing production code takes time. Currently the time-consuming actions
(July 2023) are: -

-   3-4 minutes for a typical **backend** build
-   5-6 minutes for a typical **frontend** build
-   10-15 minutes for a typical **stack** build
-   "N" minutes your time to verify the production stack is behaving as you expect

In summary, you should set aside at least 45 minutes of your time in order
to make and check a production release of the fragalysis stack.

When you are ready to release a production version of the **stack** you **MUST**: -

#.  Decide which **backend** and **frontend** versions should be used for the
    new stack image.
#.  The **backend** and **frontend** **MUST** have production-grade
    tags on their corresponding ``production`` branches - you **MUST NOT**
    use tags that are not on production branches
#.  Using the chosen versions edit (and then commit) the stack repository's
    ``.github/workflows/build-main.yaml`` file: -

    #.  Replace the value of the ``env`` variable ``BE_IMAGE_TAG``
        with your chosen version of the backend container image
    #.  Replace the ``FE_IMAGE_TAG`` with your chosen version of the
        frontend code (the variable is a GitHub *reference* and can
        be a set to a tag as well as a branch name)

#.  Tag the stack repository with your chosen **stack** tag.

    #.  The preferred style of tags is ``YEAR.MONTH.ITERATION``, i.e.
        ``2023.06.1`` for the first release in June 2023. The month
        is a 2-digit value with a leading zero if necessary.

The action of tagging the **stack** ``master`` branch will result in automated
execution of the project's CI and CD processes, automatically deploying the resultant
stack image to the ``production-stack`` **Namespace** of the
production Kubernetes cluster.

Example
*******

To deploy a new production **stack** version ``2023.06.2`` based
on **backend** ``2023.05.1`` and **frontend** ``2023.05.4`` set the
workflow file variables to this::

    BE_IMAGE_TAG: 2023.05.1
    FE_IMAGE_TAG: 2023.05.4

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
