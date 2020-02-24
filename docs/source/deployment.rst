**********
Deployment
**********

.. epigraph::

    Fragalysis Stack deployment procedures and the role of AWX (Ansible Tower)
    in the Fragalysis Stack *kubernetes* process.

The deployment of the Fragalysis Stack, i.e. it deployment
to a cloud-based Kubernetes cluster will be managed by `Ansible`_ playbooks
(and Roles) located in the `DLS Kubernetes`_ GitHub project and an
installation of an `AWX`_ server, a web-based user interface, REST API, and
task engine built on top of `Ansible`_, which will be used to initiate
deployments.

The vision is that a single playbook (Role) will be employed for both *official*
(DEV and PROD) and *developer* stack deployments to Kubernetes. This *play*
will employ variables and role-based access privileges on the
AWX server in order to spin-up each *flavour* [#f1]_ of the stack.

Other playbooks will permit, for example, the simple deployment of Graph
databases to the cluster.

Deployments (plays) are likely to require a number of sensitive values
(tokens, passwords and the like) which will need to be limited
to specific *Teams* of *Users*. Management of this aspect of Ansible
is complex but it is simplified through the use of `AWX`_.

AWX Fundamentals
================

AWX is a task engine built on top of Ansible that is able to simplify, manage
monitor application deployments through the use of Ansible playbooks present
in repositories (GitLab, GitHub etc.). We're not going to go into detail
about how the AWX server we use is fully configured, instead we're just going
to explore some key aspects that are essential to deploying the Fragalysis
Stack.

To run a playbook in AWX you typically need to create the following minimum
set of objects: -

*   An **Organisation**
*   A **Team**
*   A **User**
*   An **Inventory** and **Hosts**, often something simple like ``localhost``
*   **Credentials**, like Kubernetes cluster credentials
*   A **Project**, which is a reference to a GitHib project containing the play
*   A **Job Template**, that joins the inventory, credentials and project
    together with the opportunity to over-ride default variables in the
    corresponding play

Sensitive Material (Ansible Vault)
----------------------------------

Deployment of the stack relies on some sensitive variables that may include
things like hostnames, users and passwords.

To simplify automated deployment this information is stored in this repository
in an encrypted form using `Ansible Vault`_. The AWX server is in possession of
the encryption key (itself encrypted) so the **Job Template** that relies on
these variables can safely decrypt them when the corresponding playbook is
executed.

Deploying a user stack
======================

The AWX server should have been setup with **Job Templates** to deploy and
un-deploy stack instances and when you login these are likely to be called: -

1.  **Fragalysis Stack (Kubernetes)**
2.  **Fraglaysis Stack (Kubernetes) [DESTROY]**

If you login the the AWX server instance you should see these **Job Templates**
in the *Resources -> Templates* view.

.. epigraph::

    The Fragalysis Stack application is deployed to Kubernetes from container
    images present on a public registry (i.e. Docker Hub). To deploy your stack
    you will first need to have built your container image and pushed it
    to somewhere like Docker Hub.

To deploy your stack you should click on the **Fragalysis Stack (Kubernetes)**
**Job Template**, where you'll have an opportunity to fine-tune the deployment
for you specific image. That essentially means ensuring the following variables
are set for your needs [#f2]_: -

1.  ``stack_image`` - the container registry project and image name for
    your stack, i.e. ``xchem/fragalsyis-stack`` for official images.
2.  ``stack_image_tag`` - the tag you've assigned to your image (i.e. ``latest``)
3.  ``stack_hostname`` - the hostname that's used to route fragalysis traffic
    to the cluster

With variables set you just **SAVE** them (if you've changed them)
and then click **LAUNCH** to run the deployment playbook.

Ingress and namespace
---------------------

Your stack is deployed to a Kubernetes `namespace`_ that's unique to you.
The playbook will display this value at the end of the deployment along with
the URI that should direct traffic to your stack instance.

Debugging the stack
-------------------

*TBD*

*   **kubectl**
*   **Pod Logs**
*   **Pod Shells**

Loading target data
===================

You can load data into a Fragalysis Stack using the *Data Loader* role and
accompanying AWX **Job Templates**. You should find a
**Fragaysis Stack Data Loader** **Job Template**, which relies on a loader
container image that can synchronise data from an AWS S3 bucket.

When you run the loader job you simply need to ensure that the
following Job Template variables are appropriately set::

    stack_name
    loader_image_registry
    loader_image
    loader_image_tag
    loader_data_origin

Preparing new target data
-------------------------

If you have new data you wish to deploy it first needs to be uploaded
to your chosen S3 bucket. For example, if the AWS S3 bucket is ``dls-fragalysis``
and you have data in the directory ``2020-02-34T12`` you can use the following
AWS CLI command [#f3]_ to upload it for use by the loader::

    aws s3 sync 2020-02-24T12 s3://dls-fragalysis/django-data/2020-02-24T12

Once done you ca use ``2020-02-24T12`` as the ``loader_data_origin`` value in
your loader Job.

.. rubric:: Footnotes

.. [#f1] *Flavours* being the official development (``latest``) and production
        (*tagged*) stack images along with any number of user stacks (limited
        by the available Kubernetes cluster resources).

.. [#f2] There are a some other variables but these are the key ones.

.. [#f3] You will need AWS credentials to do this.

.. _ansible: https://github.com/ansible/ansible
.. _ansible vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _dls kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git
.. _awx: https://github.com/ansible/awx
.. _namespace: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
