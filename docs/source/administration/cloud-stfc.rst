#####################
Cloud Provider (STFC)
#####################

Notes for the `STFC`_ OpenStack cloud provider compute instances.

*******************
Instance base image
*******************

The cluster nodes are based on a refined image called
``ubuntu-bionic-xchem-noupdate4-noquattor`` [#f1]_. This special Ubuntu image
(prepared by the STFC team) is also pre-configured to disable automated system
updates driven by the provider's use fo the `Quattor`_ toolkit
(see the provider's `NoQuattor`_ notes).

If the automated updates are not disabled there's a risk that the node's
Docker service gets regularly stopped and updated.

*   This image *MUST* be used for all Kubernetes compute instances that
    you create using Rancher **Node Templates**.
*   This image should also be used for additional compute resources, like an
    **NFS server** providing NFS volumes to the clusters.
*   This image should also be used for the Rancher **RKE nodes**.

It the image cannot be used for an instance follow the provider's `NoQuattor`_
notes on how to disable automated updates.

.. _noquattor: https://stfc-cloud-docs.readthedocs.io/en/latest/howto/PreventAutomaticUpdates.html?highlight=noquattor
.. _quattor: https://www.quattor.org
.. _stfc: https://openstack.stfc.ac.uk

.. rubric:: Footnotes

.. [#f1] ID: 12cd22a2-637f-490e-b703-681dace0f761
