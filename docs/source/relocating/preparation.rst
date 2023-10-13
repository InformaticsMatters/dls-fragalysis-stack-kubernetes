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

**********************
The production backups
**********************

The keycloak database is backed up using the STFC cluster's NFS server (``192.168.253.39``).
This server serves the developer and production clusters and contains dedicated volumes
for dynamic allocation of NFS volumes for both clusters, another volume for
production stack database and media replication.

All volumes are mounted in the server's ``/nfs`` directory.

You will need to select a backup and get this off the STFC cloud so that it is
accessible to your destination (AWS EKS) cluster - ideally in an AWS S3 bucket.

.. note::
    You are expected to have `rclone`_ installed on the NFS server,
    configured with access to a suitable AWS S3 bucket to copy the files to.

You should expect ``rclone`` to have an ``aws-im`` remote configured.
To use it you will need to set the standard AWS enviornment variables:::

    export AWS_ACCESS_KEY_ID=00000000000000
    export AWS_SECRET_ACCESS_KEY=000000000000000000000

With this done you should be able to inspect the content of the ``aws-im`` remote,
where you should find the bucket ``im-fragalysis``::

    rclone lsd aws-im:im-fragalysis

*****************
Keycloak database
*****************

The keycloak database is regularly backed, at 7 minutes past every hour.
The backup files are written to the ``pg-bu`` NFS **PVC** in the ``im-infra`` **Namespace**.
At the time of writing the volume used is ``pvc-5fad6224-8ad9-40b0-a3eb-aa6c9c845d49``,
and you should find this on the NFS server in the directory::

    /nfs/kubernetes-prod/im-infra-pg-bu-pvc-5fad6224-8ad9-40b0-a3eb-aa6c9c845d49

A small number of **hourly** backups are maintained and you should find these in the
``hourly`` subdirectory using a naming convention like::

    backup-[ISO8601 date and time]-dumpall.sql.gz

These files are a **dump-all** backup of the entire keycloak PostgreSQL database used
by Keycloak. Select one and, using ```rclone`` replicate it to an AWS S3 bucket::



**************************
Fragalysis django database
**************************

****************
Fragalysis media
****************

.. _ansible-gizmos: https://github.com/InformaticsMatters/ansible-gizmos
.. _rclone: https://rclone.org
