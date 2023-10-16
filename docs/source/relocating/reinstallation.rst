########################
Installation and recovery
########################

*************
Prerequisites
*************

For a Stack **without access to a Graph database** you will need the following: -

*   A compatible kubernetes cluster (i.e. Kubernetes 1.23)
*   Worker nodes, with each that providing at least 18Gi RAM and 8 cores with
    a combined total of at least 25Gi RAM cores and 12 cores.
*   A ``KUBECONFIG`` file (providing admin access to the cluster)
*   A compatible kubectl client (i.e. kubectl 1.23)
*   An ACME/let's encrypt account (for SSL certificates) (`letsencrypt`_)
*   `Poetry`_

.. note::
    You could create a cluster with one worker of 16 cores and 32Gi RAM, or two
    worker nodes, each providing 8 cores and 16Gi RAM. On AWS having multiple nodes
    will probably be no real advantage. AWS EKS is extremely robust and resilient
    and the cost of will ultimately depend on the total cores and RAM you're using.

***********
The cluster
***********

.. warning::
    To avoid the following steps for disturbing any local **KUBECONFIG** file you may
    have defined you should run ``unset KUBECONFIG`` before proceeding.

Create a cluster in AWS using `eksctl`_. The best way to do this is byt defining
yor cluster in a ``cluster.yaml`` file. The following example, which creates
a Kubernetes 1.23 cluster in  London (``eu-west-2``), should be sufficient
for our needs::

    ---
    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig

    metadata:
      name: fragalysis-production
      region: eu-west-2
      version: '1.23'

    availabilityZones:
    - eu-west-2a
    - eu-west-2b
    - eu-west-2c

    managedNodeGroups:
    - name: mng-1
    # The 2xlarge is an 8 core 32Gi instance
    instanceType: m5.2xlarge
    minSize: 1
    maxSize: 1
    desiredCapacity: 1
    volumeSize: 80
    volumeType: gp2
    labels:
      informaticsmatters.com/purpose-core: 'yes'
      informaticsmatters.com/purpose-worker: 'yes'
      informaticsmatters.com/purpose-application: 'yes'

This file can be found in the `dls-fragalysis-stack-kubernetes`_ repository
(as ``eks-relocation/cluster.yaml``).

.. note::
    The schema for the ``cluster.yaml`` file can be found on the `exksctl schema`_ page.

It is vitally important that the cluster version you have chosen is compatible
with the kubernetes cluster we are relocating. At the time of writing this
is **1.23**.

With a cluster configuration available, create it with the following command::

    eksctl create cluster -f cluster.yaml

The cluster should be ready in about 15 minutes. Once it is ready you will find
that cluster credentials were added in ``~/.kube/config``.

if you need to you can list and select a kubernetes context using the context ``NAME``
using ``kubectl``::

    kubectl config get-contexts
    kubectl config set current-context MY-CONTEXT

You'll now be able to inspect your new cluster with ``kubectl``, where you should
discover one node::

    kubectl get nodes

*************************
Public IPv4 IP addressing
*************************

Using the example cluster file your cluster node should have been allocated a
publicly accessible IP address. You can find the associated IP address using the
AWS console.

As this address may change if the node is replaced by AWS you might want to consider
**allocating** your own floating IP address (using the AWS console and region you have
chosen) and **associating** it to one of the EC2 nodes in your cluster.
This will ensure that you are in better control of IP routing to the cluster.

CHECK IF THIS IS ACTUALLY REQUIRED

**************
Domain routing
**************

With the cluster prepared nwo is the time to arrange for the original domain name
to be routed to the IP address assigned to the Kubernetes cluster. For us this will
be::

    fragalysis.diamond.ac.uk
    *.xchem.diamond.ac.uk (for the kycloak server)

Do this as soon as you can. DNS changes may just take a few minutes but they may
also take a few hours.

*****************************
Preparation (base components)
*****************************

Before installing Keycloak and the Fragalysis Stack you will need to configure and
install some base components, namely: -

*   Install an NGINX **Ingress Controller**
*   Install the SSL **Certificate Manager**

But first, if you need to, set the ``KUBECONFIG`` environment variable to point to
your ``KUBECONFIG`` file. This wil be used by the ``kubectl`` client to access your
cluster and our playbooks::

    export KUBECONFIG=/path/to/your/kubeconfig

Ingress Controller
==================

Using ``kubectl`` install a recent NGINX Ingress Controller::

    repo=https://raw.githubusercontent.com/kubernetes/ingress-nginx
    path=deploy/static/provider/cloud/deploy.yaml
    version=controller-v1.9.1

    kubectl apply -f ${repo}/${version}/${path}

.. note::
    You can check the condition of the installation (which may take a few minutes)
    by inspecting the **Pods** in the ``ingress-nginx`` namespace::

        kubectl get pods --namespace ingress-nginx

Certificate Manager
===================

Using ``kubectl`` install a recent Certificate Manager::

    repo=https://github.com/cert-manager/cert-manager/releases/download
    path=cert-manager.yaml
    version=v1.13.1

    kubectl apply -f ${repo}/${version}/${path}

.. note::
    You can check the condition of the installation (which may take a few minutes)
    by inspecting the **Pods** in the ``cert-manager`` namespace::

        kubectl get pods --namespace cert-manager

You will also need to provide a **ClusterIssuer** definition that allows the application
**Ingress** definitions to trigger the automatic creation of SSL certificates. We use
``ACME`` (Let's encrypt) and suggest you do to. For ACNE you will need to have registered
and have the email address you used to register.

Armed with your ACME account email address create a file called ``cluster-issuer.yaml``
with the following content (replacing ``<EMAIL-ADDRESS>`` by one appropriate for you)::

    ---
    kind: ClusterIssuer
    apiVersion: cert-manager.io/v1
    metadata:
      name: letsencrypt-nginx-production
    spec:
      acme:
        email: <EMAIL-ADDRESS>
        privateKeySecretRef:
          name: letsencrypt-nginx-production
        server: https://acme-v02.api.letsencrypt.org/directory
        solvers:
        - http01:
            ingress:
              ingressClassName: nginx

You will find an example in the ``eks-relocation`` directory that you can edit.
The name of the **ClusterIssuer** is important, and it is expected to be
called ``letsencrypt-nginx-production``.

Once you have a valid **ClusterIssuer** you can then apply the definition to
your cluster::

    kubectl apply -f cluster-issuer.yaml

**************
Infrastructure
**************

With the base components installed you can now install the infrastructure.

For our application **Pods** we will need to label the worker nodes in the cluster.

If you've used the example ```cluster.yaml``file you can skip these labelling commands
and the ``eksctl`` utility will ensure that any nodes it created will have the
appropriate labels applied.

To label nodes we apply them to each node. Run the following for each node in your
cluster::

    node=<NODE-NAME>
    kubectl label nodes ${node} informaticsmatters.com/purpose-core=yes
    kubectl label nodes ${node} informaticsmatters.com/purpose-worker=yes
    kubectl label nodes ${node} informaticsmatters.com/purpose-application=yes

From this point we rely on Ansible playbooks that are provided in the
the Informatics Matters `ansible-infrastructure`_ repository, so you will need to clone
the recommended version now::

    git clone https://github.com/InformaticsMatters/ansible-infrastructure.git
    cd ansible-infrastructure
    git checkout 2023.3

Al the playbooks are controlled by variables that we typically define in a
YAML *parameter* file. A number of parameter files exist in the root of the
repository, encrypted using `ansible-vault`_. You will need to create your own
parameter file and decide whether you want to encrypt it. We suggest you do,
in case it contains sensitive information.

Use ``parameters.template`` as a template for your own parameter file.

For this exercise the following, written to ``parameter.yaml`` (ignored by the
project gitignore file) should suffice for an AWS EKS cluster, replacing
``<ADMIN-PASSWORD>``, ``<HOSTNAME>``, and ``<KEYCLOAK-PASSWORD>`` as appropriate::

    ---
    cm_state: absent
    ic_state: absent
    efs_state: absent
    cinder_state: absent
    ax_state: absent

    pg_version: 12.3-alpine
    pg_vol_storageclass: gp2
    pg_vol_size_g: 18
    pg_bu_state: absent
    db_user: governor
    db_user_password: <ADMIN-PASSWORD>

    kc_version: 10.0.2
    kc_hostname: <HOSTNAME>
    kc_admin: admin
    kc_admin_password: <KEYCLOAK-PASSWORD>

.. warning::
    As we're replicating an existing installation be sure to use the same
    usernames and passwords used in the original installation.

With parameters set we should now be able to deploy the infrastructure::

    ansible-playbook site.yaml -e @parameters.yaml

********
Keycloak
********

****************
Production Stack
****************


.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure
.. _ansible-vault: https://docs.ansible.com/ansible/latest/vault_guide/index.html
.. _dls-fragalysis-stack-kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes
.. _poetry: https://python-poetry.org
.. _letsencrypt: https://letsencrypt.org
.. _eksctl: https://eksctl.io/getting-started
.. _eksctl schema: https://eksctl.io/usage/schema
