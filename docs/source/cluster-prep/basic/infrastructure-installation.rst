*****************************
Installing the Infrastructure
*****************************

The Fragalysis Stack depends on Kubernetes services and objects created by our
`ansible-infrastructure`_ project. A basic set of parameters that can be used
to create a basic infrastructure (with and without Keycloak)

.. note:: Allow **15 minutes** to complete this task, which includes
          installation of an PostgreSQL database and AWX.

With the cluster and **kubeconfig** file available we can create the
essential underlying software infrastructure.

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
    $ git checkout tags/2020.12

From here you should follow the infrastructure project's **"Getting Started"**
guide and then its **"Creating the Infrastructure"** guide. Importantly, in
the **Creating** sub-section, instead of using the
``site-im-main-parameters.vault`` file we use ``site-im-demo-parameters.vault``,
which requires its own vault key.

Ensure the file contains settings suitable
for your cluster, which you an do by decrypting on-the-fly
using `Ansible Vault`_::

    $ ansible-vault edit site-im-demo-parameters.vault

You will need to pay special attention to the following variables::

    kc_hostname
    ax_hostname


To install AWX you will need the context name of the cluster,
located in your kubeconfig file::

    contexts:
    - name: "im-demo"
      context:
        user: "im-demo"
        cluster: "im-demo"

Passing this into the playbook with ``-e ax_kubernetes_context=im-demo``.

Now install the infrastructure (with any changes made to the vault file
and saved)::

    $ ansible-playbook \
            -e "@site-im-demo-parameters.vault" \
            -e ax_kubernetes_context=im-demo \
            site.yaml \
            --ask-vault-pass
    [provide the im-demo vault key]

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

Allow approximately **6 minutes** for the infrastructure provisioning
to complete.

Once it's installed you should be able to navigate to the AWX application
server using the address you gave it, or the one in the
``site-im-demo-parameters.vault`` file if you used that.

With this done we can move to configuring AWX.

.. _ansible vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure
