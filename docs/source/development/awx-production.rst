#########################
The AWX Production Server
#########################

You will find the Production AWX server at
``https://awx-xchem-production.informaticsmatters.org``. Only a limited
number of users will have access to this server as it is used to control
the **Staging** and **Production** deployments of the Fragalysis Stack and
the Production **Graph database**.

There are Jobs to update the Staging and Production stacks but no Jobs to
destroy (delete) them. Both the Production and Staging stacks are expected
to be persistent deployments that change but they are never removed.

Jobs controlling the Graph Database
===================================

Graph
    Blah

Graph [DESTROY]
    Blah

Jobs Controlling the Production Stack
=====================================

Production Fragalysis Stack
    Blah

Production Fragalysis Stack (Version Change)
    Blah

Production Fragalysis Stack Database Replicator (CronJob)
    Blah

Production Fragalysis Stack Media Replicator (CronJob)
    Blah

Production Media Loader
    Blah

Jobs Controlling the Staging Stack
==================================

Staging Fragalysis Stack
    Blah

Staging Fragalysis Stack (Version Change)
    Blah

Staging Fragalysis Stack Database Replicator (CronJob)
    Blah

Staging Fragalysis Stack Media Replicator (CronJob)
    Blah

Staging Media Loader
    Blah
