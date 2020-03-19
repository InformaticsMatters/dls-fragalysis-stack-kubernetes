***************************
Setting up the Demo cluster
***************************

.. epigraph::

    Notes on configuring the demonstration Fragalysis AWS-based
    kubernetes cluster for Diamond Light Source. These notes describe the
    software setup based on the the assumption that you have a viable cluster
    and are in possession of the ``kubeconfig`` file, have an AWS IAM Role,
    access to the wider internet and can pull code from git repositories,
    Docker Hub and images hosted on private (GitLab) registries.

To setup the cluster you need to complete the following steps: -

*   Create the software **infrastructure**
*   Configure the **AWX application server**

With the infrastructure and AWX application server setup
we then deploy applications into the cluster using the Jobs
that were configured above, in step 2.

*   Deploy a fragmentation **graph database**
*   Deploy **Fragalysis**
*   Deploy the Informatics Matters **Squonk** application
*   Deploy the Informatics Matters **Fragnet Search** application

.. note:: Allow **3 hours** to install the infrastructure and
          all the application components.

Prerequisites
#############

Before trying to setup the demo you will need: -

A cluster
*********

#.  An AWS kubernetes cluster, with: -

    *   At least 5 spare CPU cores
    *   At least 8Gi of available memory
    *   With one node having at least 3 free cores and 6Gi of available RAM

#.  A storage class called "gp2" available to the cluster
#.  A route to the cluster, normally through an Application Load Balancer
    in EKS or an Elastic IP associated with one of your application nodes
    if you're using EC2
#.  Suitable Domain re-directions, a wildcard or individual routes for: -

    *   Keycloak
    *   AWX
    *   Fragalysis
    *   Fragnet Search
    *   Squonk

#.  An AWS IAM user capable of managing the EC2 cluster
#.  A **node pool** of application nodes
#.  A **node pool** of graph nodes
#.  The deployment benefits from node labels and taints (see `labels and taints`_)
#.  The cluster **kubeconfig** file
#.  The cluster must have access to GitHub and GitLab
#.  The cluster must have access to Docker Hub
#.  The cluster must have access to Ansible Galaxy

An AWS S3 Bucket
****************

#.  Fragmentation and Fragalysis data available in an AWS S3 **Bucket**

A host
******

#.  A unix control machine from where you'll work
    (OSX 10.15.3 was used to prepare this demo)
#.  Python 3 (Python 3.8.1 was used to prepare this demo), ideally
    using a virtual environment engine like conda
#.  The git client
#.  Ansible vault credentials to decrypt the encrypted variables in this
    repository
#.  Access to GitHub
#.  Access to Ansible Galaxy

Create the software infrastructure
##################################

.. note:: Allow **15 minutes** to install the infrastructure, which consists
          of an EFS provisioner, PostgreSQL database, Keyclock
          and AWX.

With the cluster and **kubeconfig** file available we can create the
essential underlying software infrastructure.

The infrastructure is created using playbooks and roles present in the
Informatics Matters `infrastructure`_ GitHub repository.

Start in a suitable working directory on your control machine (desktop or
laptop) and prepare a directory that you can use for Python virtual
environments.

Create a working directory and create and enter a Python 3 virtual
environment::

    $ mkdir -p ~/Code/im-demo
    $ cd ~/Code/im-demo
    $ conda create -n im-demo python=3.8
    $ conda activate im-demo

Clone the infrastructure project and checkout the stable revision used
for the demo::

    $ git clone https://github.com/InformaticsMatters/ansible-infrastructure.git
    $ cd ansible-infrastructure
    $ git checkout tags/2020.7

From here you should follow the infrastructure project's **"Getting Started"**
guide and then its **"Creating the Infrastructure"** guide. Importantly, in
the **Creating** sub-section, instead of using the
``site-im-main-parameters.vault`` file we use ``site-im-demo-parameters.vault``,
which requires its own vault key.

Ensure the file contains settings suitable
for your cluster, which you an do by decrypting on-th-fly::

    $ ansible-vault edit site-im-demo-parameters.vault --ask-vault-pass

You will need to pay special attention to the following variables::

    kc_hostname
    ax_hostname


With any changes made to the vault file and saved install the infrastructure::

    $ ansible-playbook -e "@site-im-demo-parameters.vault" site.yaml \
            --ask-vault-pass
    [then provide the im-demo vault key]

If you don't want to (or can't) use the ``im-demo`` parameter file you can
still install the infrastructure in your cluster by providing your own
parameter file, and define values for the following variables::

    cm_letsencrypt_email
    db_user
    db_user_password
    pg_vol_storageclass
    pg_bu_vol_storageclass
    kc_admin_password
    kc_hostname
    ax_admin_password
    ax_hostname
    ax_kubernetes_context

Allow approximately **6 minutes** for the infrastructure provisioning
to complete.

Once it's installed you should be able to navigate to the AWX application
server using the address you gave it, or the one in the
``site-im-demo-parameters.vault`` file if you used that.

With this done we can move to configuring AWX.

Configure the AWX application server
####################################

.. note:: Allow 2 minutes

Configuration of the AWX server is achieved with the playbooks and roles
in the Informatics Matters `DLS Kubernetes`_ GitHub repository. The demo
configuration will create the following objects: -

*   An organisation
*   A team
*   A user

Clone the project and checkout the stable revision used for the demo::

    $ cd ~/Code/im-demo
    $ git clone https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git
    $ cd dls-fragalysis-stack-kubernetes
    $ git checkout tags/2020.1
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml

Armed with the AWS ``admin`` user password you can configure the
AWX applications server using its playbook, passing the password
in via the command-line::

    $ ansible-playbook -e "tower_password=<PASSWORD>>" \
            site-awx-configuration.yaml \
            --ask-vault-pass

This will create an *organisation*, *team*, *labels* and a *user*.
The various *credentials* required for the playbooks will be added
along with *projects* (references to the playbooks in our git repositories)
and *job-templates*.

If you login to the AWX server now you should be able to navigate to all of
these objects.

.. _labels:

Deploying the demo applications
###############################

With the AWX server configured we can now run the **Job Templates** that
are responsible for deploying the various applications.

Start by logging into the AWX application server as the demo user ``demo``.
From there you should be able to navigate to the **Templates** screen where
all the templates are presented to you.

The Fragmentation Graph Database
********************************

.. note:: Allow 40 minutes

Deploy the Fragmentation graph by *launching* the **Fragmentation Graph**
template.

**screenshot**

As the graph initialisation takes some time the job does not
(at the tim eof writing) wait for the graph to initialise. We therefore use the
``kubectl`` command-line to check on the status of the graph::

    $ kubectl get all -n graph

Where you should
**TBD**

Fragalysis
**********

.. note:: Allow 10 minutes

With the graph installed we can now start the Fragalysis Stack and its
*Data Loader*.

Deploy Fragalysis by *launching* the **Fragslysis Stack**
template.

**screenshot**

As the stack initialisation is a little more deterministic (and short)
the job waits for the stack to become ready before finishing. When this job
finishes you know the stack is "up and running".

You can't use the stack without any target data so you now need to run
the *Data Loader*.

Deploy the loader by *launching* the **Fragslysis Stack Data Loader**
template. This job will also wait for the loader to complete. If you're
running a typical **ALL TARGETS** load this might take around 40 minutes.
The job will time-out after an hour.

Squonk
******

.. note:: Allow 5 minutes

Squonk can be deployed using AWX.

Deploy Squonk by *launching* the **Squonk** job template.
Squonk should be installed and running in less than 5 minutes.

**screenshot**

With squonk deployed you can then inject the standard RDKit pipelines
with another Job. Install the pipelines by running the **Squonk (RDKit Pipelines)**
Job.

Fragnet Search
**************

.. note:: Allow 1 minute

**TBD**

Labels and taints
#################

Application nodes
*****************

Nodes for general application deployment employ the label **key** ``purpose``
and **value** ``application``. This is optional, deployments request nodes
with this label but are happy to reside on any node.

Graph database nodes
********************

To create nodes to be used exclusively for the graph database we rely on
*labels* and *taints*. The graph database deployment benefits from nodes
with the label **key** ``purpose`` and **value** ``bigmem`` and the *taint*
**key** ``purpose``, **value** ``bigmem`` and **effect** ``NoSchedule``.

Destroying the cluster
######################

**TBD**

Finally, remove the infrastructure namespace, which will remove **Keycloak**,
**PostgreSQL** and the **AWX application server** and the persistent volumes
used by it and the database::

    $ kubectl delete namespace/im-infra

You can now dispose of the cluster.

.. _infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure.git
.. _dls kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git