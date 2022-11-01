############################
New Branch Policy (Nov 2022)
############################

.. epigraph::

    The new branch and build policy introduced November 2022.

****
Why?
****

Prior to this we were building production stacks from frontend branches and
backend latest images. This is error-prone. Between the time taken to decide
to create a production image and actually creating one a new backend latest
stack could have been pushed or the frontend's branch could have changed.

By using tags from backend and frontend...

* We create a much more reliable and repeatable build process
* We have a clear reference to the underlying code for defect tracking

By using a staging branch in the backend and frontend we are able to safely
collect all the changes for the next release separately from the existing
production branch.

This allows us to make hot-fixes directly on or on branches created from the
current production branch without the risk of polluting the production release
with lots of other changes which are now confined to the staging branch

By using multiple "integration branches" (i.e. `yellow` and `blue`),
created from the staging branch, we are able to work on features that are
scheduled for different production releases simultaneously

.. epigraph::

    A little bit of extra work for increased reliability and traceability

*********************
Branch and tag policy
*********************

There are two **PERMANENT** (**protected**) branches in the backend repository.
A ``staging`` branch and a ``production`` branch.

You will also find one or more **integration** branches, used to integrate the
features for an active major/minor release. These might be used for milestones
and the naming is to be declared but it could be the milestone ``ms-2022-08-18``
or a more friendly name like the designated colour that's referred to during
meetings (``yellow``, ``purple``). So, if code for ms-2022-08-18 (yellow) is
being actively developed you might expect to find a ``yellow`` integration
branch.

Developers implement features (or fix bugs) on **feature** branches.

GitHub Actions result in new container images for: -

*   For every commit to a **feature**/**integration** branch
    (tagged using the branch name slug, i.e. yellow)
*   For every commit to the ``staging`` branch (tagged using latest)
*   For every non-production tag/release on the ``staging`` branch
*   For every production tag/release on the ``production`` branch

Summarised in the diagram below: -

..  image:: ../images/branch-topology-nov-2022/fragalysis-branch-topology.001.png

Automated stack builds
======================

For every change to either the ``staging`` or ``production`` branch on the
**backend** (or **frontend**), a GitHub workflow Action triggers a build of the
**stack** image (in its repository) using the image just built in the backend.

Stack images built this way are launched by a user running a suitable
AWX Ansible Job Template.

As illustrated in the diagram below: -

..  image:: ../images/branch-topology-nov-2022/fragalysis-branch-topology.004.png

Control variables
=================

For all this to work the **backend** repository needs access to a number of
control variables defined either as a GitHub Repository (or Organisational)
Secret or as part of a GitHub Environment.

.. epigraph::

    Refer to the build staging workflow for details of the expected variables
    and their expected origin (Secret or Environment).

To trigger a downstream build of the **stack** for example you will need to
define the following Secrets: -

*   ``TRIGGER_DOWNSTREAM`` (set to "yes")
*   ``STACK_USER``
    (A GitHub user account that build the stack)
*   ``STACK_USER_TOKEN``
    (A suitable "personal access token" for thew stack user account)

***************************
BE and FE role in the stack
***************************

The **backend** is the source of Django application that forms the backend of
the **stack**. The by-product of a backend build is a container image
pushed to Docker hub. The backend is the ``FROM`` image used by the stack.

Building stacks for staging deployments
=======================================
Whenever the ``staging`` branch of the **backend** is built it triggers a
build of the **stack**, producing a stack image labelled ``latest``.
These ``latest``images are manually deployed to the designated Kubernetes
namespace using a production cluster AWX Job Template.

The ``latest` stack is convenient for quickly testing the current development
code but a stack that is expected to be promoted to production the developer
needs to make sure the stack is based on a fixed copy of the backend and
frontend. This is accomplished by applying a tag to the backend (or frontend)
staging branch.

So, if you are testing code for a new release to production: -

*   Your feature should have already been merged onto the corresponding ``staging``
    branch for the repository that is changing, having passed through the
    appropriate integration branch for unit/functional testing.
*   Tag (or create Release from) the corresponding ``staging`` branch
    *   The tag (applied to the staging branch) should be a
         non-production-grade tag, e.g. ``1.0.0-beta.1`` or ``1.0.1-rc.2``,
         but **NOT** a tag like ``1.0.0``

Tagging your repository's ``staging`` branch will trigger a build of the stack
using your tag and it will be visible through the versioning display of the UI.

It is this **stack** image (built from tagged references to the backend
and frontend) that you should be testing if you anticipate creating a
production image.

Building stacks for production deployment
=========================================
When a **stack** built as described above is considered suitable for
production a new stack should be built from tags made on the ``production``
branches of the underlying repositories.

For example, if you have made changes to the backend
(using the tag ``1.0.0-rc.1`` on the backend ``staging`` branch: -

*   Merge the backend ``staging`` branch to the backend ``production`` branch
    (no stack will be built from build activity on production branches)
*   When the new build is complete create a **release** or **tag**
    the ``production`` branch, this time with the corresponding production
    tag, e.g. ``1.0.0``. Again, no stack will be built

When the build is complete...

*   Edit the stack repository's ``.github/workflows/build-main.yaml`` workflow
    file and replace the existing tag variable's value with the tag just created.
    There's a variable for the backend tag (``BE_IMAGE_TAG``) and a variable for
    the frontend tag (``FE_BRANCH``)
*   Commit the workflow file
*   Create a new **Release** in the stack repository, i.e. ``1.0.0``

The corresponding GitHub Action will ensure the new production build will be
automatically deployed to the cluster.

***********************************
How the automated stack build works
***********************************
The ``fragalayis-stack`` repository is triggered by certain builds in the
upstream repositories ``fragalysis-frontend` and ``fragalysis-backend``.
The build triggers are described below.

Frontend
========

Changes to staging branch
-------------------------
All changes on its **staging** branch are handled by its ``build-staging.yaml``
workflow. Pushes to the branch, excluding tags, result in a build that
eventually ends in running the **Trigger stack** step. This results in
triggering the fragalysis-stack ``build main`` workflow
(in the ``fragalysis-stack`` repository).

By default the frontend sends the following two important variable values to
the stack build. It triggers a stack build from the frontend code in this
branch and the backend code from the most recent (tagged) build -
i.e. the code in the most recent tag, captured in the ``stable`` image.

*    be_image_tag: stable
*    fe_branch: staging

Changes to the production branch
--------------------------------
Changes on its **production** branch are handled by its ``build-production.yaml``
workflow. Like the **staging** branch above it triggers a build in the stack
repository, sends the following two important variable values to the stack
build: -

*    be_image_tag: stable
*    fe_branch: production

Backend
=======
The backend repository build is slower than the frontend because the backend
is responsible for building the stack base container image. A number of
image tags are used, depending on which branch is being built.
Once the build is complete, like the frontend, the stack
repository build is triggered.

Changes to staging branch
-------------------------
All changes on its **staging** branch are handled by its ``build-staging.yaml``
workflow. Pushes to the branch, excluding tags, result in a build that
eventually ends in running the **Trigger stack** step.

On the staging branch the backend build a container image with the
Docker tag ``latest``.

By default the **backend** sends the following two important variable values
to the stack build. It triggers a stack build using the frontend code from its
``production`` branch and the backend container images tagged ``latest``.

*   be_image_tag: latest
*   fe_branch: production

Changes to production branch
----------------------------
Changes on its **production** branch are handled by its ``build-production.yaml``
workflow. This workflow only runs when the backend production branch is tagged.

Like the **staging** branch above it triggers a build in the stack repository,
sends the following two important variable values to the stack build: -

*   be_image_tag: stable
*   fe_branch: production
