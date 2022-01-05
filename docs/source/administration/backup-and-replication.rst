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

Backup are generally only running for the **Production** stack.

A Backup is performed every hour at HH:51, the backup volume is a cluster-local
volume created by the installed kubernetes NFS provisioner. The
``database-backup`` volume is primarily for recovery back to production.

- This backup is driven by the ``postgres-backup-hourly`` **CronJob** in the
  ``production-stack`` namespace.

An additional backup of the **Production** database is performed every day at
04:04. This backup is written to pre-allocated NFS volume
(``/nfs/kubernetes-db-replica``), a volume that is designed to be shared
with the **Development** cluster.

- This backup is driven by the ``postgres-replicator-backup`` **CronJob**
  in the ``production-stack`` namespace.
