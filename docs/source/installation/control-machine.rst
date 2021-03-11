###########################################
Command-Line Requirements (Control Machine)
###########################################

Requirements for the machine you'll be running ansible playbooks from.

1.  **Applications**. the control machine will need: -

    *   Python 3.8
    *   Git

2.  **GitHub**. In order to deploy the infrastructure the control
    machine will need access to GitHub where Ansible playbooks and roles are
    located, specifically: -

    * InformaticsMatters/ansible-infrastructure
    * InformaticsMatters/dls-fragalysis-stack-kubernetes

3.  **Ansible Galaxy**. In order to configure the infrastructure
    AWX server the control machine will need access to
    `Ansible Galaxy <https://galaxy.ansible.com>`_

4.  **LENS**. `Lens`_ is respectable Kubernetes IDE. We use it to monitor
    our own clusters and, if you do not currently use a Kubernetes dashboard
    or IDE, you might want to use it too.

5.  **Credentials**. You will need credentials that allow admin privilege
    access to the Kubernetes cluster and, if using AWS S3 as the origin for
    Graph fragment and Fragalysis Stack media data, a user with **Get** access
    for your chosen AWS S3 *bucket*.

6.  A basic understanding of `Ansible`_ (v2.9) would be an advantage - e.g.
    playbooks, roles, role structure and variable definitions.

7.  An understanding of `YAML`_ files.

*******************
Virtual environment
*******************

A lot of our work, and Ansible, will require the execution of Python scripts.
Typically this is done from within a `virtual environment`_. With the above
requirements clone this repository and follow its ``README.md``
**Preparation** Notes.

.. _ansible: https://docs.ansible.com/ansible/latest/index.html
.. _lens: https://k8slens.dev
.. _virtual environment: https://docs.python.org/3/tutorial/venv.html
.. _yaml: https://yaml.org
