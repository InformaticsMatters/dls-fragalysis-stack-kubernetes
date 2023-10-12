########################
Preparing for relocation
########################

.. warning::
    Before going further it would be wise to suspend any user activity on the
    production stack - to prevent the Fragalysis data from changing while the
    move to the new cluster tales place. You could, for example, scale-down the
    Fragalysis and Keycloak **Pods** (controlled by an associated Kubernetes
    **StatefulSet**).

.. note::
    You cannot be using ``kuebectl`` for port forward or be using a kubectl-like
    application (like ``lens``) during this process.

*****************
Keycloak database
*****************

To do this we use the Informatics Matters `ansible-gizmos`_ repository. It contains
Ansible playbooks (roles) that can be used to extract PostgreSQL data and store it
locally or on an S3 bucket.

Familiarize yourself with the **Gizmos** repository ``README`` any any existing
site parameter files relating to the ``site-k8s-database-dump`` play,
these might be useful as a template for your own playbook parameters.

If we assume the ``KUBECONFIG`` file that gives you access to the production cluster
is available in the file ``~/k8s-config/config-xchem-production-admin`` you
will need to provide the following values for the play's variable in a suitably
named yaml file (e.g. ``keycloak-move.yaml``)::

    kdd_db_namespace: im-infra
    kdd_db_database: keycloak
    kdd_db_admin_user: governor
    kdd_db_file_basename_prefix_pattern: "keycloak-"
    kdd_db_kubeconfig: ~/k8s-config/config-xchem-production-admin

With this done you should be able to backup the Keycloak database with::

    ansible-playbook site-k8s-database-dump.yaml -e @keycloak-move.yaml

You will find the database dump  in ``/tmp`` in a ``backup.sql`` file
prefixed by ``keycloak-`` (e.g. ``/tmp/keycloak-backup.sql``).

**************************
Fragalysis django database
**************************

****************
Fragalysis media
****************

.. _ansible-gizmos: https://github.com/InformaticsMatters/ansible-gizmos
