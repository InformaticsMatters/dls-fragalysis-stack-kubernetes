******************
Preparing for lens
******************

You will need to install `lens`_, a neat community-driven IDE for Kubernetes,
and then provide your kubernetes configuration file.

Installing lens
===============

Refer to the `lens`_ website for installation instructions. You should install
version 3.4 or better.

Provide your KUBECONFIG
=======================

The first time you start lens you will need to provide a cluster configuration.
CLick the **Add clusters** icon in the application side-bar and then select
**Custom ...** from the **Choose config:** drop-down, and then paste
the content of the kubernetes configuration file into the **Kubeconfig:**
panel and then click **Add Cluster(s)**.

.. _lens: https://k8slens.dev
