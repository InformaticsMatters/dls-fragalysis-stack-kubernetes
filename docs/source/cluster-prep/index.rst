###################
Cluster Preparation
###################

These instructions cover deployment of a basic production-grade
Fragalysis Stack (without custom authentication).

This requires the installation of the underlying infrastructure components,
which is handled by playbooks in our `ansible-infrastructure`_ repository: -

*   An ingress controller (NGINX in our case)
*   Pod Security Policies
*   Certificate management
*   A PostgreSQL database
*   `AWX`_ (the open-source upstream distribution of
    RedHat's Ansible `Tower`_)
*   An optional `Keycloak`_ server.

Once the infrastructure is installed, deployment of the Graph-based fragment
database and Fragalysis Stack is achieved through the use of *Jobs* that are
configured on the infrastructure AWX server.

What follows is a simplified guide to setting up a basic [#f1]_ deployment of
the Fragalysis Stack through a number of stages: -

..  toctree::
    :maxdepth: 2
    :caption: Installation

    requirements
    container-images
    basic/index

..  toctree::
    :maxdepth: 2
    :caption: AWX Fundamentals

    awx

.. _awx: https://github.com/ansible/awx
.. _keycloak: https://www.keycloak.org
.. _tower: https://www.ansible.com/products/tower
.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure

.. rubric:: Footnotes

.. [#f1] An cluster with an AWX server and a Fragalysis Stack without
         custom credentials or backup and recovery strategies. A cluster
         with the ability to use the stack with publicly available graph
         fragment data.
