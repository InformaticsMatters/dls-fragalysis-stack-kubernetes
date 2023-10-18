#########################
Relocation to EKS (basic)
#########################

These instructions cover the process of relocating a *basic* copy of the
production fragalysis stack to an AWS EKS Kubernetes 1.23 cluster.

By relocation we mean moving the stack from A *source* cluster to a separate
*destination* cluster..

*Basic* is meant to imply that the stack is not using any of the optional
applications like an AWX ansible playbook server, Squonk, Discourse or a Graph Database.

The relocation uses playbooks already employed by the original AWX server but also
requires some manual effort.

Before you begin you will need: -

*   A compatible AWS EKS kubernetes cluster (i.e. Kubernetes 1.23)
*   Worker nodes, with each that providing at least 18Gi RAM and 8 cores with
    a combined total of at least 25Gi RAM cores and 12 cores.
*   Kubernetes config files for the source and destination clusters
*   Access to the production AWX server
*   An AWS S3 bucket
*   The Ansible Vault secret for the sensitive stack parameters that are
    encrypted within the `dls-fragalysis-stack-kubernetes`_ repository

In order for the stack to operate it will need the following essential
**core** and **infrastructure** components in the destination cluster: -

*   At least one Persistent volume **StorageClass** (*core*)
*   An nginx **ingress controller** (*core*)
*   The kubernetes **certificate manager** to manager SSL certificates (*core*)
*   A keycloak server (*infrastructure*) [#f1]_
*   A PostgreSQL database for keycloak (*infrastructure*) [#f2]_

There are four basic steps to the relocation: -

*   Preparation
    *   Collect backups of data and media
*   Installation and recovery, which consisting of: -
    *   core components in the destination cluster
    *   Install and recover the infrastructure database
    *   Install and recover the stack

What follows is a simplified guide to relocating the production stack to an AWS EKS
cluster.

***********
Preparation
***********

Prior to relocating the production stack a we need to collect back-ups of the various
databases and the fragalysis stack media directory. Basically all the data that is too
complex to reproduce.

..  image:: ../images/frag-actions/frag-actions.018.png

The data includes: -

*   The Keycloak infrastructure database (A)
*   The fragalysis stack django database (B)
*   The fragalysis stack media directory (C)

..  toctree::
    :maxdepth: 1

    preparation

*************************
Installation and recovery
*************************

With preparation done up we can now install the infrastructure and then the stack
on the new cluster whilst also restoring the data.

..  image:: ../images/frag-actions/frag-actions.019.png

..  toctree::
    :maxdepth: 1

    reinstallation

****************************
Deploying new stack versions
****************************

With a stack running you might want to deploy a new stack version. The following
instructions cover the process of deploying a new version of the stack.

..  toctree::
    :maxdepth: 1

    updating-the-stack-image

*******
Removal
*******

When we're finished with the destination cluster we can delete it.

..  toctree::
    :maxdepth: 1

    removal

.. _dls-fragalysis-stack-kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes

.. rubric:: Footnotes

.. [#f1] Unless you can reuse an existing keycloak
.. [#f2] Unless you can reuse an existing keycloak database
.. [#f3] That excludes Squonk and a Graph Database
