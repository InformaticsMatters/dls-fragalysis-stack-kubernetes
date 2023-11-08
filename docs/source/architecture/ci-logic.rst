###################################
How the automated stack build works
###################################
The ``fragalayis-stack`` repository is triggered by certain builds in the
upstream repositories ``fragalysis-frontend`` and ``fragalysis-backend``.
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

Changes to the production branch
================================
Changes on its **production** branch are handled by its ``build-production.yaml``
workflow. Like the **staging** branch above it triggers a build in the stack
repository.

*******
Backend
*******

Changes to staging branch
=========================
All changes on its ``staging`` branch are handled by its ``build-staging.yaml``
workflow. Pushes to the branch, excluding tags, result in a build that
eventually ends in running the **Trigger stack** step.

On the staging branch the backend build a container image with the
Docker tag ``latest`` or the repository tag if the ``staging`` branch is tagged
(e.g. ``1.0.5-rc.1``).

Changes to production branch
============================
Changes on its ``production`` branch are handled by its ``build-production.yaml``
workflow. This workflow only runs when the backend production branch is tagged.
