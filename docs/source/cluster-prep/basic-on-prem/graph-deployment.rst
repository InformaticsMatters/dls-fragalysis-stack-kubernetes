############################
Deploying the Fragment Graph
############################

.. note:: Allow **2 hours** to install all of the applications.

The playbooks that we'd normally run from AWX can be executed form the
command line. That's what we'll be doing here.

The steps we'll follow here are: -

*   Clone the Graph playbook repository
*   Create a parameter file to satisfy your cluster
*   Run the playbook

********************
Clone the graph repo
********************

The repository contains playbooks and roles for the deployment of
a `neo4j`_ graph database and associated fragmentation data. From your virtual
environment clone it and (ideally) switch to the most recent tag::

    $ git clone https://github.com/InformaticsMatters/docker-neo4j-ansible
    $ cd docker-neo4j-ansible
    $ git checkout tags/2.4.3

*****************
Create parameters
*****************

The Graph deployment is flexible and is controlled by a number of
Ansible variables. To control your deployment you are likely to have to
define your own set of variable values in a *parameter* file - not all of
those that are set in the repo may be of use to you.

A ``parameters-template.yaml`` file contains a small set of *significant* ones.

Copy the example in the repository, inspect it and set/change any values you
need to::

    $ cp parameter-template.yaml parameter.yaml
    [edit parameter.yaml]

``parameter.yaml`` is protected from being committed by the project's
``.gitignore`` file.

.. epigraph::

    The ``parameter-template.yaml`` contains only an example set of role
    variables - you should familiarise yourself with the role and
    inspect the other parameters (in the role's ``defaults/main.yaml``
    and ``vars/main.yaml``), just in case you also need to adjust them.

****************
Run the playbook
****************

With a set of parameters created, deploy the Graph using the ``site.yaml``
playbook::

    $ ansible-playbook -r @parameter.yaml site.yaml
    [...]

As the graph initialisation can take some time the job does not
(at the time of writing) wait for the graph to initialise. We therefore use the
``kubectl`` command-line (in a separate terminal/shell) to check on the status
of the graph before moving on.

First, check that the graph namespace exists::

    $ kubectl get namespace/graph
    NAME    STATUS   AGE
    graph   Active   7s

And then *watch* the Graph Pod status until it's ``Running``. The
graph contains an initialisation container used to download the graph
data to the cluster::

    $ kubectl get pod/graph-0 -n graph -w
    NAME      READY   STATUS     RESTARTS   AGE
    graph-0   0/1     Init:0/1   0          14s
    graph-0   0/1     Init:0/1   0          95s
    graph-0   0/1     Init:0/1   0          100s
    graph-0   0/1     PodInitializing   0          108s
    graph-0   1/1     Running           0          114s

Once you see ``Running`` the Pod has started and you can ``ctrl-c`` from the
command.

The graph needs to *import* the downloaded files into a graph database, which
can take a significant length of time, depending on the data that's been
downloaded.

You can *follow* the Graph Pod's logs and wait for the import process to complete.
The graph import typically involved 4 stages that are easily followed from the
logs.

The output here has been truncated because there is a lot of it.

Importantly, to be confident the deployment has worked, you must see: -

*   A section starting ``(1/4) Node import``
*   A section starting ``(2/4) Relationship import``
*   A section starting ``(3/4) Relationship linking``
*   A section starting ``(4/4) Post processing``

And, finally, you're waiting to see the word ``Finished.`` issued by the
``cypher-runner.sh`` script::

    $ kubectl logs pod/graph-0 -n graph -f
    [...]
    (1/4) Node import 2020-09-16 03:18:22.955+0000
    Estimated number of nodes: 40.16 M
    Estimated disk space usage: 8.64 GB
    Estimated required memory usage: 1.49 GB
    .......... .......... .......... .......... ..........   5% ∆4s 813ms
    .......... .......... .......... .......... ..........  10% ∆3s 609ms
    .......... .......... .......... .......... ..........  15% ∆3s 405ms
    .......... .......... .......... .......... ..........  20% ∆3s 406ms
    [...]
    (4/4) Post processing 2020-09-16 04:13:13.062+0000
    Estimated required memory usage: 1020.01 MB
    .--.-..... .......... .......... .......... ..........   5% ∆7s 601ms
    .......... .......... .......... .......... ..........  10% ∆11s 413ms
    .......... .......... .......... .......... ..........  15% ∆12s 209ms
    .......... .......-.. .......... .......... ..........  20% ∆3s 906ms
    [...]
    2020-03-19 14:25:08.527+0000 INFO  ======== Neo4j 3.5.5 ========
    2020-03-19 14:25:08.532+0000 INFO  Starting...
    2020-03-19 14:25:14.865+0000 INFO  Bolt enabled on 0.0.0.0:7687.
    2020-03-19 14:25:16.444+0000 INFO  Started.
    2020-03-19 14:25:17.531+0000 INFO  Remote interface available at http://localhost:7474/
    (cypher-runner.sh) Thu Mar 19 14:26:05 UTC 2020 Setting neo4j password...
    (cypher-runner.sh) Thu Mar 19 14:26:07 UTC 2020 No legacy script.
    (cypher-runner.sh) Thu Mar 19 14:26:07 UTC 2020 Trying /data/cypher-script/cypher-script.once...
    (cypher-runner.sh) Thu Mar 19 14:26:08 UTC 2020 .once script executed.
    (cypher-runner.sh) Thu Mar 19 14:26:08 UTC 2020 No .always script.
    (cypher-runner.sh) Thu Mar 19 14:26:08 UTC 2020 Touching /data/data-loader/cypher-runner.executed...
    (cypher-runner.sh) Thu Mar 19 14:26:08 UTC 2020 Finished.

Once you see that you can ``ctrl-c`` from the *follow* command and continue
with the remaining applications.

.. _neo4j: https://neo4j.com
