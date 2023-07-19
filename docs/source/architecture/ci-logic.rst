###################################
How the automated stack build works
###################################
The ``fragalayis-stack`` repository is triggered by certain builds in the
upstream repositories ``fragalysis-frontend` and ``fragalysis-backend``.
The build triggers are described below.

********
Frontend
********

Changes to staging branch
=========================
All changes on its **staging** branch are handled by its ``build-staging.yaml``
workflow. Pushes to the branch, excluding tags, result in a build that
eventually ends in running the **Trigger stack** step. This results in
triggering the fragalysis-stack ``build main`` workflow
(in the ``fragalysis-stack`` repository).

By default the frontend sends the following two important variable values to
the stack build. It triggers a stack build from the frontend code in this
branch and the backend code from the most recent (tagged) build -
i.e. the code in the most recent tag, captured in the ``stable`` image.

*    ``be_image_tag`` will have the value ``stable``
*    ``fe_branch`` will have the value ``staging``

Changes to the production branch
================================
Changes on its **production** branch are handled by its ``build-production.yaml``
workflow. Like the **staging** branch above it triggers a build in the stack
repository, sends the following two important variable values to the stack
build: -

*    ``be_image_tag`` will have the value ``stable``
*    ``fe_branch`` will have the value ``production``

*******
Backend
*******
The backend repository build is slower than the frontend because the backend
is responsible for building the stack base container image. A number of
image tags are used, depending on which branch is being built.
Once the build is complete, like the frontend, the stack
repository build is triggered.

Changes to staging branch
=========================
All changes on its ``staging`` branch are handled by its ``build-staging.yaml``
workflow. Pushes to the branch, excluding tags, result in a build that
eventually ends in running the **Trigger stack** step.

On the staging branch the backend build a container image with the
Docker tag ``latest`` or the repository tag if the ``staging`` branch is tagged
(e.g. ``1.0.5-rc.1``).

By default the **backend** sends the following two important variable values
to the stack build: -

*   ``be_image_tag`` will have the value ``latest``
    Or the ``staging`` **tag** if the backend build on staging is the
    result of a tag.
*   ``fe_branch`` will have the value ``production``

The resultant **stack** image will be tagged ``latest``.

Changes to production branch
============================
Changes on its ``production`` branch are handled by its ``build-production.yaml``
workflow. This workflow only runs when the backend production branch is tagged.

Like the **staging** branch above it triggers a build in the stack repository,
sending the following two important variable values to the stack build: -

*   ``be_image_tag`` will have the value of the **tag** applied to the backend
    production branch (e.g. ``1.0.5``)
*   ``fe_branch`` will have the value ``production``

The resultant **stack** image will be tagged ``latest``.
