#######################
Fragmentation Processes
#######################

..  epigraph::

    The fragmentation process runs in Kubernetes and is able to process
    vendor molecule data into a form that can be used in our graph database
    and fragalysis.

************
Architecture
************

Converting vendor data into a form suitable for a graph requires the use of
two container images (a *player* and a *fragmentor*) and a PostgreSQL database.
The process is divided into a number of "plays" that *standardise* the vendor
data, *fragment* it (into a database) and then *extract* the fragments to form
a graph.

The "plays" are managed by the *player* container, which launches a number
of *fragmentor* containers in order to distribute the workload amongst a
number of parallel processes that share a common volume for data sharing.
AWS S3 is used as a source of vendor data and used to write the final results
as illustrated in the following diagram: -

..  image:: ../images/im-kubernetes-fragmentor/im-kubernetes-fragmentor.001.png

..  note::
    The role of this section of the documentation is not to explain the actual
    process but to explain how to execute it, within a Kubernetes cluster.

************
Installation
************

Our `fragmentaor-ansible`_ repository contains a detailed description of
the installation and execution of the fragmentor and it describes what you'll
need to do to process a small set of molecules (up to a few thousand).
Refer to it for up-to-date instructions but you will need: -

1.  A kubernetes **Namespace**
2.  A **ReadWriteMany** storage class (like NFS or EFS)
3.  Nodes with our **Node Labels** for the fragmentation Pods
4.  A **postgres database** (and user)
5.  An AWS **Bucket**
6.  Plenty of spare cores and memory

Follow the **Kubernetes namespace setup** section of the repo's README
for a fuller description of how to setup the cluster.

..  warning::
    If you're expect to process a large number of molecules you'll need to
    consult with us to understand what preparation you'll need before you
    embark on any fragmentation as using the basic setup described will not
    be suitable.

*********
Execution
*********

With the cluster setup (and databases installed in the **Namespace**) you
should be able to run the fragmentor plays [#f1]_. This is
documented in the `fragmentaor-ansible`_ repository README's
**Running a play** section.

This essential requires the one-time preparation of the database
(handled by the player) and then a fragmentation run using the
following plays: -

-   **standardise**
-   **fragment**
-   **inchi**
-   **extract**

Refer to the `fragmentaor-ansible`_ repository for further details.

.. rubric:: Footnotes

.. [#f1] You will need molecule data in a supported format stored in your
         bucket

.. _fragmentaor-ansible: https://github.com/InformaticsMatters/fragmentor-ansible.git
