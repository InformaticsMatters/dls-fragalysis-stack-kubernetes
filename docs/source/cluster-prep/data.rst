####################
Graph and Stack data
####################

The Fragment Graph database needs to be loaded with fragment data before
it can be used and the Fragalysis Stack needs to be loaded with target/media
data before it can be used.

This data typically resides on an NFS server or an S3 object store.

The graph database pulls the data down as it initialises but the stack,
once running, needs to be *loaded*. The stack is often re-loaded with more
data as needs dictate.

.. note:: You need to have access to this data before you can deploy the
          graph or the stack.

**********
Graph data
**********

Graph data consists of *Node* and *Relationship* definitions, typically
stored in a series of compressed CSV files.

On S3 this data is stored as objects on a *path*. As an example
you might have ``fragalysis-graph`` bucket and the path
``combination/3``. The bucket and path are not important but the Graph's
initialisation (consisting of a load phase) will simply copy all the objects
on the path (not recursively) and expect them to represent a viable graph.

You must have the following files/objects on the *path*: -

*   ``load-neo4j.sh``

**********
Stack data
**********

Stack data consists of *Target* definitions, typically
stored on a bucket *path*. the files are peculiar to the Fragalysis
application. Their their format is not covered here.

Stack data is stored in directories, normally of the format
``<YYYY>-<MM>-<DD>T<HH>` but other directories, like ``ALL_TARGETS``
may also exist. If you have target data in the data directory ``2020-01-01T04``
this is your *path*.

Target data must exist in the follwing bucket and path: -

*   ``s3://<BUCKET>/jango-data/<PATH>``
