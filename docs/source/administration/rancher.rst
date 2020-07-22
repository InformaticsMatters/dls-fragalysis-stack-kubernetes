##################
The Rancher Server
##################

The **DEVELOPMENT** and **PRODUCTION** clusters have been created with
and are managed by `Rancher`_, deployed to the STFC/OpenStack cluster
on a dedicated kubernetes cluster configured using `RKE`_.

A simplified depiction of the clusters can be seen in this diagram.
Each cluster consists of key ``etcd`` and ``control plane`` nodes
and various worker (``app`` and ``graph``) nodes. The instances are created
and managed by the Rancher server.

..  image:: ../images/frag-travis/frag-travis.016.png

A full description of the Rancher installation and its configuration
can be found in the following external (GoogleDoc) document: -

*   `OpenStack K8S clusters with Rancher`_ (AWS)

..  warning::

    The cluster instances are created automatically by the Rancher server.
    **DO NOT edit or delete any compute instance via the STFC/OpenStack
    console** that may be a Kubernetes instance (*etcd*, *control plane* or
    *worker*). To help you identify them the instances use a naming convention.
    Instance names that belong the the cluster hosting Rancher begin ``rke-``.
    Instance names that belong to the **DEVELOPMENT** or **PRODUCTION** cluster
    begin ``xch-``.

.. _rancher: https://rancher.com/products/rancher/
.. _rke: https://rancher.com/products/rke/
.. _OpenStack K8S clusters with Rancher: https://docs.google.com/document/d/15ffwm5daCW5gJ1ZNpX6A9mYP-rw3Bvyr9nZyiWKte00/edit?usp=sharing
