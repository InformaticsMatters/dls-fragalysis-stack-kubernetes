#######################
Backups and Replication
#######################

AWX Jobs (that create Kubernetes **CronJobs** and **Jobs**) are used to
perform regular Database backups and replicate these and Media between the
Production and Development clusters.

- The Production cluster is home to the **Staging** and **Production** stacks
- The Development cluster is home to stacks controlled by individual developers
- An NFS provisioner takes care of PVC allocations for use within each cluster
- NFS volumes are created where they're needed to share data between the clusters

*******
Backups
*******

Backups (*database and media*) typically only run for the **Production** stack.

A database backup is performed every hour at HH:51, the backup volume is a
cluster-local volume created by the installed kubernetes NFS provisioner. The
``database-backup`` volume is primarily for recovery back to production.

- This backup is driven by the ``postgres-backup-hourly`` **CronJob** in the
  ``production-stack`` namespace.

An additional backup of the **Production** database is performed every day at
02:04 UTC for the purposes of providing a source of data to load the **Staging** stack.
This backup (taken from the most recent backup at the time it runs) is written
to pre-allocated NFS volume (``/nfs/kubernetes-db-replica``), a volume that is
designed to be shared with the **Development** cluster.

- The **database** backup is driven by the ``postgres-replicator-backup`` **CronJob**
  in the ``production-stack`` namespace.
- The **media** backup is driven by the ``media-replicator`` **CronJob**
  in the ``production-stack`` namespace.

Details
=======

The **Production** PostgreSQL backup relies on a ``/backup`` volume used by
the corresponding ``postgres-back-hourly`` **CronJob**. The volume will
have an ``/hourly`` directory where you will find hourly backups (for the last
24 hours) in compressed backup files in the ``/hourly``directory.
A typical file wil be named ``/backup-2022-11-28T08:51:08Z-dumpall.sql.gz``.

The backup size is about 3.3GiB (Nov 2023).

Backup are created from within the CronJob using the command
``pg_dumpall --username=admin --no-password``

Database credentials can be found in the ``database`` **Secret**
in the ``production-stack`` **Namespace**. You'll find the ``root_password``
(for the built-in postgres user) and a ``user_password`` (for the the
fraglaysis user). There is a ``frag`` database with all privileges granted to
the ``fragalysis`` user.

Media content is backed up by the ``media-replicator`` **CronJob**. The files
are written to an NFS server (``130.246.213.182``) directory
``/nfs/kubernetes-media-replica``.

The replicator (which provides data as a source for the **Staging** Stack)
runs once a day, at approximately 02:04 UTC. A ``postgres-replicator``,
which takes that most recent postgres backup, also runs at 02:04 UTC.
