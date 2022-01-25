#######
Backups
#######

These instructions cover the backups that take place, primarily on the
**Production Stack** (in the Production cluster).

****************
Production Stack
****************

If configured, regular backups of the database and media are performed from
Pods instantiated by kubernetes **CronJobs** that run within the
``production-stack`` namespace. The CronJobs are deployed from the AWX
production server using the following Job Templates: -

-   **Production Fragalysis Stack Database Replicator (CronJob)**
-   **Production Fragalysis Stack Media Replicator (CronJob)**

At the time of writing both jobs are set to run daily at 2:04 AM.

The containers that perform the backups are, respectively: -

-   ``informaticsmatters/sql-backup:stable``
-   ``informaticsmatters/volume-replicator:stable``

They create backups of the database (compressed) and the Media
(uncompressed using rsync) on the following NFS server volumes: -

-   ``/nfs/kubernetes-db-replica``
-   ``/nfs/kubernetes-media-replica``

The backups form the source of Production replicas
(see :doc:`../production-replication/index`).
