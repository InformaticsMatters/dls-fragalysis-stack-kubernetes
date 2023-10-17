##########
Relocation
##########

These instructions cover the process of relocating the production fragalysis stack
to an AWS EKS Kubernetes 1.23 cluster. By relocation we mean moving the stack from one
cluster to another.

.. note::
    These instructions *do not* cover the provisioning of the AWX server,
    Squonk or Discourse

before you begin you will need::

*   Access to the production AWX server
*   The Ansible Vault secret for the sensitive stack parameters that are
    encrypted within the `dls-fragalysis-stack-kubernetes`_ repository

In order for the stack to operate it will need the following essential (minimal)
**core** and **infrastructure** components: -

*   An nginx ingress controller
*   A certificate manager to manager SSL certificates
*   A keycloak server [#f1]_
*   A PostgreSQL database for keycloak [#f2]_

You can rely on our *built-in* infrastructure components (which come with
a number of cluster pre-requisites) that are handled by our
`ansible-infrastructure`_ repository.

With these installed an(and restored) you can then deploy the Stack and then restore
its Django database and media directory.

What follows is a simplified guide to relocating the production stack [#f3]_.

***********
Preparation
***********

Prior to relocating the production stack a number of resources need to be backed up.
This is essentially all the data that is impossible to reproduce.

..  image:: images/frag-actions/frag-actions.018.png

It includes: -

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
on the new cluster whilst also restoring the data, remembering that we will need
to preserve any postgres passwords used in the original cluster.

..  image:: images/frag-actions/frag-actions.019.png

The minimal installation does not include the following: -

*   The AWX server

..  toctree::
    :maxdepth: 1

    reinstallation

*******
Removal
*******

..  toctree::
    :maxdepth: 1

    removal

.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure
.. _dls-fragalysis-stack-kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes

.. rubric:: Footnotes

.. [#f1] Unless you can reuse an existing keycloak
.. [#f2] Unless you can reuse an existing keycloak database
.. [#f3] That excludes Squonk and a Graph Database
