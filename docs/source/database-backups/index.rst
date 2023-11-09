#######
Backups
#######

These instructions cover the backups that take place, primarily on the
**Production Stack** (in the Production cluster).

If configured, regular backups of the database and media are performed from
Pods instantiated by kubernetes **CronJobs** that run (typically within the
``production-stack`` **Namespace**).

The CronJobs are deployed as part of the initial stack deployment
(handled by the **Production Fragalysis Stack** AWX **Job Template**).

The following variables control the backup behaviour: -

- ``database_bu_state`` (set to ``present``)
- ``database_bu_vol_storageclass`` (set to a suitable storage class, e.g. ``longhorn``)

Setting these wil result in the deployment of the ``postgres-backup-hourly`` CronJob,
which by default will backup the stack's django database at 51 minutes past each hour.

Other variables you can use (with defaults) are: -

- ``database_bu_vol_size_g`` (``4``)
- ``database_bu_hourly_schedule`` (``'51 * * * *'``)
- ``database_bu_hourly_history`` (``24``)
