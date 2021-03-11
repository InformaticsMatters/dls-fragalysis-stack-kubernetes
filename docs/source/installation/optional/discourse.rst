#########
Discourse
#########

`Discourse`_ is an open source Internet forum and mailing list management
software application. The Fragalysis Stack can be configured to interact with
a Discourse server.

************
Installation
************

You can skip this section if you have your own Discourse server - this section
deals with installing Discourse using our our custom build and our Ansible
role to deploy it in your cluster. What follows are basic instructions for
deploying Discourse to your cluster using our Ansible playbook and role.

Before we begin we must be in possession of the cluster's `kubeconfig`_ file
and correctly defined environment variables for your cluster::

    K8S_AUTH_HOST
    K8S_AUTH_API_KEY

You can refer to our guide :doc:`../basic/infrastructure-installation`
which used the command-line to run our Kubernetes-based playbooks.

Start in a suitable *working directory* on your control machine (desktop or
laptop) and and create and enter a Python 3 virtual environment::

    $ conda create -n discourse python=3.8
    $ conda activate discourse

Clone the Discourse playbook and checkout a stable revision::

    $ git clone https://github.com/InformaticsMatters/discourse-ansible.git
    $ cd discourse-ansible
    $ git checkout tags/2021.5
    $ pip install -r requirements.txt

With suitable configuration parameters set (see below) you can install
Discourse using Ansible::

    $ ansible-playbook -e @parameters.yaml site.yaml

Installation may take 10 to 20 minutes to complete.

Configuration
=============

Always refer to the project's READMe.md for up-to-date information, but Discourse
will require setting a number of control parameters before you install it.
Create a ``parameters.yaml`` and use that to define your custom configuration.

The most common control variables are defined in the role's **defaults**
(``roles/discourse/defaults/main.yaml``) with other, less common ones
in **vars** (``roles/discourse/vars/main.yaml``). You should review all the
variables, which have accompanying documentation, especially those whose
value is ``SetMe``.

Importantly you must provide: -

*   **StorageClass** definitions for the Discourse, Redis and Postgres
    containers that are part of our Discourse.
*   **SMTP** values for email notifications
*   A **root password** for Postgres
*   A **namespace**
*   A **hostname**
*   Discourse **admin password** and **email address**

*******************************
Post-installation configuration
*******************************

With Discourse installed you now need to login, using the admin user
and password you used in the installation steps above, and configure
the running server.

To enable Fragalysis to talk to Discourse, the following minimal steps
are required:

1.  Set up a user called **fragalysis** and give them moderator privileges.
    Note that by default only admins can create categories in Discourse,
    but the fragalysis user must be able to do this. In Discourse, therefore,
    the admin security setting: **Allow moderators to create new categories**
    (or **Allow moderators to manage categories and groups** depending
    on version) must be enabled.

2.  Create an **API key** (under Admin..API) called, say, **FragalysisAPI** and
    enable for all users (Note that Fragalysis posts will be made under the
    user's own user name - only categories are set up as the fragalysis user).
    Make a note of the key.

3.  The Discourse HOST and API key values are passed to Fragalysis
    using variables defined in ``roles/fragalysis-tack/defaults/main.yaml``.
    Look for variables that start ``stack_discourse_``.

.. _discourse: https://www.discourse.org
.. _kubeconfig: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
