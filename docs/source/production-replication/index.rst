######################
Production Replication
######################

"Production Replication" is a process that allows the Production stack's
database and media (on the Production cluster) to be replicated to another
stack. The target stack can be on the Production or Development cluster.

This process is used to instantiate the **Staging Stack**
(which runs in the Production Cluster) using a copy of the the current
Production Database and Media directory. The use fo this process
allows the Staging stack to be used for pre-production
testing of features on a near-identical stack prior to tagging the stack's
repository for automatic deployment to Production.

As well as being used for the Staging Stack you can production data
to *prime* a developer stack (on the Developer Cluster). This provides a
developer to test their code on stack that's nearly identical to the Production
stack.

********************************
Replicating to the Staging stack
********************************

The staging stack can be instantiated from the current [#f1]_ Production data
using a **Workflow Template** on the production AWX server.

-   **Staging Stack (Production Replica) [START]**

This *workflow* executes a number of underlying Job Templates that run in the
``staging-stack`` namespace to: -

1.  Instantiate a new Database instance
2.  Recover the production database content to it (from its NFS backup)
3.  Instantiate a new stack
4.  Recover the stack Media content (from its NFS backup)

The user is expected to provide the stack image tag in the workflow's
**EXTRA VARIABLES** parameter section. The **most important** variable 
is ``stack_image_tag``, which sets the image tag for the deployed stack.

.. warning::
    You **MUST** set the ``stack_image_tag`` to the same value used in the
    production stack prior to replicating the production data as the staging stack's
    database model must be the same as that used in production. After recovery you
    can deploy a new stack but during replication it must be the same.

..  note::
    The time it take for the stack to become usable will depend on the database
    and media content. For a new stack the media directory is the most
    time-consuming element and (at the time of writing) takes more than
    1 hour 15 minutes to complete. Subsequent start times are significantly
    reduced (typically around 8 to 10 minutes) as the media directory is
    preserved between stack instances.

Once the stack is ready the user executes any tests they see fit and then,
once this version of the stack is no longer needed, runs the **Stop**
template on the AWX server: -

-  **Staging Stack (Production Replica) [STOP]**

The stop template removes the stack, database and the database volume.
The stack's media volume is left intact, which results in faster instantiation
of subsequent stacks.

..  note::
    After the first staging instantiation you can expect subsequent stacks
    to be ready after about 10 minutes (depending largely on media changes),
    and the stop operation to complete in about 1 minute.

********************************
Replication to a Developer stack
********************************

Developers are able to start their stacks (on the Development cluster)
using the same process described above but this requires them to manage
their own Workflow Template.

An example pair of Templates can be found on the AWX developer server: -

-   **Production Replica (Alan) [START]**
-   **Production Replica (Common) [STOP]** (everyone can use this one)

.. rubric:: Footnotes

.. [#f1] Based on the latest backup, typically from 2:04 AM
