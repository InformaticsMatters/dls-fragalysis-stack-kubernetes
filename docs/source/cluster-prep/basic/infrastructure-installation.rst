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
    $ git checkout tags/2020.28
    $ pip install -r build-requirements.txt
    $ sphinx-build -b html doc doc/build

..  note::
    Try to use the latest tag that's available. At the time of writing it was
    ``tags/2020.28``.

With documentation built, the root of it will be found at
``doc/build/index.html``.

Follow the infrastructure project's **Getting Started**
guide and then its **Creating the Infrastructure** guide before returning here.

Once the infrastructure is installed you should be able to navigate to the
AWX application server using the hostname you gave it.

With this done we can move to :doc:`awx-configuration`.

.. _ansible vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _ansible-infrastructure: https://github.com/InformaticsMatters/ansible-infrastructure
.. _kubeconfig: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
