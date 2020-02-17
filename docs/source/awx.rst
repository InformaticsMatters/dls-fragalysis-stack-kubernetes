*******************
AWX and Deployments
*******************

.. epigraph::

    The role of AWX in the Fragalysis Stack *deployment* process.

The deployment of the Fragalysis Stack, i.e. it deployment
to a cloud-based Kubernetes cluster will be managed by `Ansible`_ playbooks
(and Roles) located in the `DLS Kubernetes` GitHub project.

A single playbook (Role) will be employed for both *official*
(DEV and PROD) and *developer* stack deployments to Kubernetes with variables
controlling the *flavour* of the deployment.

Other playbooks will permit, for example, the simple deployment of Graph
databases to the cluster.

Deployments (plays) are likely to require a number of sensitive values
(tokens, passwords and the like) which will need to be limited
to specific *Teams* of *Users*. Management of this aspect of Ansible
is complex but it is simplified through the use of `AWX`_, a web-based user
interface, REST API, and task engine built on top of `Ansible`_.

.. _ansible: https://github.com/ansible/ansible
.. _dls kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.git
.. _awx: https://github.com/ansible/awx
