#######################
Configuring AWX (Basic)
#######################

.. note:: Allow 5 minutes to complete this task,
          which involves configuring and checking the AWX application server

Configuration of the AWX server is achieved with a parameter file
in the Informatics Matters `DLS Kubernetes`_ GitHub repository and the
Ansible Galaxy `AWX Composer`_ Role .

Clone the project into the working directory you created while following the
:doc:`infrastructure-installation` guide::

    $ cd <working directory>
    $ git clone https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git
    $ cd dls-fragalysis-stack-kubernetes
    $ git checkout tags/2020.34
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml

The demo configuration will create the following objects: -

*   An organisation
*   Credentials
*   A team
*   A demo user
*   Projects
*   Job Templates

Start by copying the ``config-basic-template.yaml`` file to ``config-basic.yaml``
(which is protected from being committed) and then review it and provide
values for all fo the ``SetMe`` instances in the file.

The file defines a ``tower`` variable, used by our ``AWX Composer`_
Ansible Galaxy role.

.. warning::
    Before configuring the AWX server you will need AWS (typically for S3 access)
    and Kubernetes credentials. Providing these results in the composer
    creating the ``aws (SELF)`` and ``k8s (SELF)`` built-in credentials that are
    essential for deploying the Fraglaysis Stack.

You will have to provide suitable environment variables for the *built-in*
credentials::

    $ export AWS_ACCESS_KEY_ID=00000000
    $ export AWS_SECRET_ACCESS_KEY=00000000

    $ export K8S_AUTH_HOST=https://1.2.3.4:6443
    $ export K8S_AUTH_API_KEY=kubeconfig-user-abc:00000000
    $ export K8S_AUTH_VERIFY_SSL=no

You can now configure the AWX applications server
using the infrastructure playbook and the ``config-basic.yaml`` file.
From your the root of the clone of the `dls kubernetes`_ repository run::

    $ ansible localhost \
        -m include_role -a name=informaticsmatters.awx_composer \
        -e @awx-configuration/config-basic.yaml

Once complete you should be able to login to the AWX server and
navigate to the Templates page and see all the available jobs.

.. _dls kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes
.. _awx composer: https://github.com/InformaticsMatters/ansible-role-awx-composer
