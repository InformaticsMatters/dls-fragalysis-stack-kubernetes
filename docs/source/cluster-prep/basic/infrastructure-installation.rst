#####################################
Installing the Infrastructure (Basic)
#####################################

The Fragalysis Stack depends on Kubernetes services and objects created by our
`ansible-infrastructure`_ project. A basic set of parameters that can be used
to create a basic infrastructure (with and without Keycloak)

.. note:: Allow **15 minutes** to complete this task, which includes
          installation of a PostgreSQL database and AWX.

Before we begin we must be in possession of the cluster's `kubeconfig`_ file.

Start in a suitable *working directory* on your control machine (desktop or
laptop) and and create and enter a Python 3 virtual environment::

    $ mkdir -p ./im-demo
    $ cd im-demo
    $ conda create -n im-demo python=3.8
    $ conda activate im-demo

Clone the infrastructure project and checkout the stable revision used
for the demo and build the HTML-based documentation::

    $ git clone https://github.com/InformaticsMatters/ansible-infrastructure.git
    $ cd ansible-infrastructure
    $ git checkout tags/2020.22
    $ pip install -r build-requirements.txt
    $ sphinx-build -b html doc doc/build

Once built, the root documentation will be found at ``doc/build/index.html``.

From here you should follow the infrastructure project's **Getting Started**
guide and then its **Creating the Infrastructure** guide. Importantly, in
the **Creating** sub-section, instead of using the ``vault`` files start with
the ``parameters.template`` file, which does not require a vault key,
and copy it as ``parameters.yaml`` (a file protected from being committed).

You need to provide values suitable for your cluster for a number of
parameters, i.e. all those with a ``SetMe`` value. Review the file and change
other values as you see fit.

To install AWX you will need the context name of the cluster,
located in your ``kubeconfig`` file::

    contexts:
    - name: "im-demo"
      context:
        user: "im-demo"
        cluster: "im-demo"

Passing this into the playbook with ``-e ax_kubernetes_context=im-demo``.

Now install the infrastructure::

    $ ansible-playbook \
            -e "@site-parameters.yaml" \
            -e ax_kubernetes_context=im-demo \
            site.yaml

Allow approximately **6 minutes** for the infrastructure provisioning
to complete.

Once it's installed you should be able to navigate to the AWX application
server using the address you gave it.

With this done we can move to :doc:`awx-configuration`.

.. _ansible vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure
.. _kubeconfig: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
