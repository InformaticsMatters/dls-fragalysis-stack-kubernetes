############
Installation
############

These instructions cover deployment of a basic production-grade
Fragalysis Stack (without custom authentication).

The Fragalysis Stack application consists of a **Stack** and a **Fragment Graph**.
These applications rely on additional *infrastructure* components in order to
operate.

You can rely on our *built-in* infrastructure components (which come with
a number of cluster pre-requisites) that are handled by our
`ansible-infrastructure`_ repository. Out infrastructure recommendation
if to include AWX and a Keycloak server

*   An NGINX ingress controller and associated Network Load balancer
*   A RWX storage class (AWS EFS in our case)
*   Pod Security Policies
*   Certificate management
*   `AWX`_ (the open-source upstream distribution of RedHat's Ansible `Tower`_)
*   A PostgreSQL database
*   An optional `Keycloak`_ server.
*   Node labels

Once the infrastructure is installed, deployment of the Graph-based fragment
database and Fragalysis Stack is achieved through the use of *Jobs* that you
configure on the infrastructure AWX server.

If you cannot install our infrastructure (i.e. you're on a secure or limited
*on-prem* cluster) you must provide: -

*   An NGINX ingress controller and associated Network Load balancer
*   A RWX storage class
*   Pod Security Policies (if using Kubernetes 1.24 or earlier)
*   Certificate management
*   Node labels

In addition to the application cluster you will need to provide an AWS S3
bucket (or buckets) from which you can serve the graph and stack data - the
applications will not work without any background data.

What follows is a simplified guide to setting up a basic [#f1]_ deployment of
the Fragalysis Stack through a number of stages: -

..  toctree::
    :maxdepth: 2
    :caption: Requirements, images and data

    cluster-requirements
    container-images
    data

..  toctree::
    :maxdepth: 2
    :caption: Installation (optional applications)

    optional/index

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
    :caption: Screenshots

    screenshots-marh

..  toctree::
    :maxdepth: 2
    :caption: AWX Fundamentals

    awx

.. _awx: https://github.com/ansible/awx
.. _keycloak: https://www.keycloak.org
.. _tower: https://www.ansible.com/products/tower
.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure

.. rubric:: Footnotes

.. [#f1] A cluster with an AWX server and a Fragalysis Stack without
         custom credentials or backup and recovery strategies. A cluster
         with the ability to use the stack with publicly available graph
         fragment data.
