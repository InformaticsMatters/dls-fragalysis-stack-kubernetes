####################################
Preparing for Kubernetes Development
####################################

In order to develop applications you are likely to need to debug **Pods**
(Containers), poke-around inside them and occasionally restart them. You can
do this with the command-line (using ``kubectl``) or with the ``lens`` IDE.

Before starting with either you will need a *configuration file*, called
a *kube config*. Your system administrator should be able to provide you
with one for the cluster you're deploying to.

Armed with this, folloo instructions based on whether you'll
be using ``kubectl`` or ``lens``.

..  toctree::
    :maxdepth: 1
    :caption: Tools

    preparing-for-kubectl
    preparing-for-lens
