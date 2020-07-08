*******************
Cluster Preparation
*******************

These instructions cover deployment of a basic production-grade
Frgalsysis Stack (without custom authentication).

This requires the installation of the underlying infrastructure components: -

*   A PostgreSQL database
*   `AWX`_ (the open-source upstream distribution of
    RedHat's Ansible `Tower`_)
*   An optional `Keycloak`_ server.
*   Pod Security Policies
*   Certificate management
*   An ingress controller (nginx in our case)

One the infrastructure is satisfied, deployment of the Graph database and
Fragalysis Stack is achieved through the use of Jobs that are configured on
the AWX server.

What follows is a simplified guide to setting up a basic [#f1]_ deployment of
the Fragalysis Stack through a number of stages: -

..  toctree::
    :maxdepth: 2
    :caption: Basics

    requirements
    container-images
    awx
    basic/index

.. _awx: https://github.com/ansible/awx
.. _keycloak: https://www.keycloak.org
.. _tower: https://www.ansible.com/products/tower

.. rubric:: Footnotes

.. [#f1] An cluster with an AWX server and a Fragalysis Stack without
         custom credentials or backup and recovery strategies. A cluster
         with the ability to use the stack with publicly available graph
         fragment data.
