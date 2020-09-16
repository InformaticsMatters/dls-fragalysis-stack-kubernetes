#####################
Development Processes
#####################

..  epigraph::

    Fragalysis Stack deployment procedures and the role of AWX (Ansible Tower)
    in the Fragalysis Stack *kubernetes* process.

The deployment of the Fragalysis Stack, i.e. its deployment
to a cloud-based Kubernetes cluster are managed by `Ansible`_ playbooks
(and Roles) located in the `DLS Kubernetes`_ GitHub project and an
installation of an `AWX`_ server, a web-based user interface, REST API, and
task engine built on top of `Ansible`_, which will be used to initiate
deployments.

Separate AWX severs exists on the **Production** and **Development** clusters.
Developers normally only have access to the server on the Development
cluster.

Deployments (plays) require a number of sensitive values
(tokens, passwords and the like) which will need to be limited
to specific *Teams* of *Users*. Management of this aspect of Ansible
is complex but it is simplified through the use of `AWX`_.

..  toctree::
    :maxdepth: 1
    :caption: Deployment Tools

    awx-development
    awx-production
    preparing-for-kubernetes
    cheat-sheets/index
    dummies-dev-setup

Sensitive Material (Ansible Vault)
----------------------------------

Deployment of the stack relies on some sensitive variables that may include
things like hostnames, users and passwords.

To simplify automated deployment this information is stored in this repository
in an encrypted form using `Ansible Vault`_. The AWX server is in possession of
the encryption key (itself encrypted) so the **Job Template** that relies on
these variables can safely decrypt them when the corresponding playbook is
executed.

Developers don't need the decryption keys so they cannot see them.

********************************************
Deploying a user stack (Development Cluster)
********************************************

The AWX server should have been setup with **Job Templates** to deploy and
un-deploy stack instances. There are also common templates to synchronise
the stack's built-in PostgreSQL database and Django media files (if required)
to those used by the Production server.

Developers will have been given access to the sever and a set of templates
should be visible to them when the login.

.. epigraph::

    The Fragalysis Stack application is deployed to Kubernetes from container
    images present on a public registry (i.e. Docker Hub). To deploy your stack
    you will first need to have built your container image and pushed it
    to somewhere like Docker Hub.

To deploy your stack you should click on Fragalysis Stack **Job Template** that
will have been created for you, i.e. **USER (<YOU>) Developer Fragalysis Stack**
This template will give you an opportunity to fine-tune the deployment
for your specific image. That essentially means ensuring the following variables
are set for your needs [#f2]_: -

1.  ``stack_image`` - the container registry project and image name for
    your stack, i.e. ``xchem/fragalsyis-stack`` for official images.
2.  ``stack_image_tag`` - the tag you've assigned to your image (i.e. ``latest``)

With variables set you just **SAVE** them (if you've changed them)
and then click **LAUNCH** to run the deployment playbook.

Ingress and namespace
=====================

Your stack is deployed to a Kubernetes `namespace`_ that's unique to you.
The playbook will display this value at the end of the deployment along with
the URI that should direct traffic to your stack instance.

Loading target data
===================

You can load target data into your stack using another AWX **Job Template**.
You should find a **User (<YOU>) Developer Data Loader** **Job Template**,
which relies on a loader container image that can synchronise data from the
internal NFS server that hosts the target data.

When you run the loader job you simply need to ensure that the
following Job Template variables are appropriately set::

    loader_data_origin
    stack_name (normally just left at 'default')

Replicating target data (from Production)
=========================================

Instead of loading your own target data you can simply replicate data from the
latest Production stack (which is made available in the early hours of each
morning) into your stack's instance.

Two **Job Templates** exist to allow this, and they can be run once your
stack has initialised: -

1.  **Common Database Replicator (One-Time)** to replicate the Production
    PostgreSQL ``frag`` database
2.  **Common Media Replicator (One-Time)** to replicate the Production
    stack's media files

Redeploying a Stack (a version or code change)
==============================================

If you've already deployed your stack and have now produced a new Docker
image (even a new ``latest`` image) you can quickly redeploy the
image by running the **User (<YOU>) Developer Fragalysis Stack (Version Change)**
Job Template.

This relies on the stack having been deployed (i.e. with a database and
persistent volumes) and simply causes the Pod to restart while also re-pulling
the image from Docker Hub.

You can just run the original **User (<YOU>) Developer Fragalysis Stack**
Job template but that takes a little longer to run.

.. rubric:: Footnotes

.. [#f1] *Flavours* being the official development (``latest``) and production
        (*tagged*) stack images along with any number of user stacks (limited
        by the available Kubernetes cluster resources).

.. [#f2] There are a some other variables but these are the key ones.

.. [#f3] You will need AWS credentials to do this.

.. _ansible: https://github.com/ansible/ansible
.. _ansible vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _aws cli: https://aws.amazon.com/cli/
.. _awx: https://github.com/ansible/awx
.. _dls kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git
.. _namespace: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
