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

*****************************
Preparation (base components)
*****************************

Before installing Keycloak and the Fragalysis Stack you will need to configure and
install some base components, namely: -

*   Install a suitable **Pod Security Policy (PSP)** (for kubernetes prior to 1.25)
*   Install an NGINX **Ingress Controller**
*   Install the SSL **Certificate Manager**

But, first, set the ``KUBECONFIG`` environment variable to point to your ``KUBECONFIG``
file. This wil be used by the ``kubectl`` client to access your cluster and our
playbooks::

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

Then, apply the definition to your cluster::

    kubectl apply -f cluster-issuer.yaml

**************
Infrastructure
**************

With the base components installed you can now install the infrastructure.

For our application **Pods** we will need to label the worker nodes in the cluster.
We do this by applying a label to each node. Run the following for each node in your
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
