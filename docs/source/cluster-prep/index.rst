############
Installation
############

These instructions cover deployment of a basic production-grade
Fragalysis Stack (without custom authentication).

The Fragalysis Stack application consists of a **Stack** and a **Fragment Graph**.
These application rely on additional *infrastructure* software in order to
operate, specifically: -

You can rely on our *built-in* infrastructure components (which come with
a number of cluster pre-requisites) that are handled by our
`ansible-infrastructure`_ repository, which installs the following: -

*   An NGINX ingress controller and associated Network Load balancer
*   A RWX storage class (AWS EFS in our case)
*   Pod Security Policies
*   Certificate management
*   `AWX`_ (the open-source upstream distribution of
    RedHat's Ansible `Tower`_)
*   A PostgreSQL database
*   An optional `Keycloak`_ server.

Once the infrastructure is installed, deployment of the Graph-based fragment
database and Fragalysis Stack is achieved through the use of *Jobs* that are
configured on the infrastructure AWX server.

If you cannot install our infrastructure (i.e. you're on a secure or limited
*on-prem* cluster) you must provide, at the very least: -

*   An NGINX ingress controller and associated Network Load balancer
*   A RWX storage class (AWS EFS in our case)
*   Pod Security Policies
*   Certificate management

In addition to the application cluster you will need to provide an AWS S3
bucket (or buckets) from whcih you can serve the graph and stack data - the
applications will not work without any background data.

What follows is a simplified guide to setting up a basic [#f1]_ deployment of
the Fragalysis Stack through a number of stages: -

..  toctree::
    :maxdepth: 2
    :caption: Requirements and images

    cluster-requirements
    container-images

..  toctree::
    :maxdepth: 2
    :caption: Installation (built-in infrastructure)

    basic/index

..  toctree::
    :maxdepth: 2
    :caption: Installation (on-prem infrastructure)

    basic-on-prem/index

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
