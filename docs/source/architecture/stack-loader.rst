############################################
The Fragalysis Stack Loader (no longer used)
############################################

The *loader* is used to provision new Fragalysis Stack data (both Django media
and the related database entries).

..  warning::
    The Fragalysis Loader is deprecated. You should be using the Stack
    loader API. The loader may be removed in future releases.

************
How it works
************

Data to be loaded is first placed on the Media NFS server, where an NFS
directory acts as the root of all of the data (``/nfs/kubernetes-fs-media``).
New data directories are typically named with the format ``YYYY-MM-DDTHH``,
e.g. ``2020-06-03T09``.

In order to load the data into a specific stack you simply run an appropriate
**Media Loader** Job on the AWX server for your cluster, providing the data
directory for the media as the Job's ``loader_data_origin`` value
(e.g. ``2020-06-03T09``).

The Job instantiates the **loader container**, which mounts the NFS directory
and copies the data into ``/code/media/NEW_DATA`` in the Stack container before
calling ``loader.py`` module in the loader Pod.

..  epigraph::

    As well as an NFS loader a loaders also exists that will copy data from
    AWS S3, although this will require suitable credentials.

***********************************
The NFS media volume (the 'origin')
***********************************

You will need to put new data files in a subdirectory of
``/nfs/kubernetes-fs-media`` on the NFS server that has been commissioned in
the STFC xchem-follow-up project.

*   The NFS server address is ``130.246.213.186`` (at the moment this is not
    available from outside the project's network).
*   The server account for connection is ``fragalysis``
*   You will need the private part of the key-pair in order to access the
    server

Data and the directory it's in must be available to all.

******************
Running the loader
******************

You will find a **Media Loader** Template Job on your cluster's AWX server.
On the production cluster you will find one for the Production stack
(**Production media Loader**) and the Staging stack (**Staging media Loader**).

*   Change the Job Template's ``loader_data_origin`` variable value
    before running the Job. The value must match a sub-directory that has been
    populated on the media volume, e.g. ``2020-06-10T09`` (i.e. the
    sub-directory not the full path).

When executed, The Job runs and waits for completion of the loader.
