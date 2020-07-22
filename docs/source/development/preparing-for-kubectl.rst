#####################
Preparing for kubectl
#####################

You will need to install a compatible version of kubectl and then
create your configuration file.

******************
Installing kubectl
******************

Follow the `Kubernetes instructions`_. If in doubt always install the very latest
version. It must be at least as good ats the one used by the cluster
(which is probably v1.17.5).

**************************
Setup your KUBECONFIG file
**************************

Kubernetes configurations (small YAML files) are usually located in
your ``$HOME/.kube`` directory. Take the configuration you've been given
and place it in a new file. For example the configuration for the
XChem Development cluster should be placed in
``$HOME/.kube/config-xchem-developer``. Set the KUBECONFIG environment
variable to the new file::

    $ export KUBECONFIG=$HOME/.kube/config-xchem-developer

You can test the config with ``kubectl`` with a simple version command,
which should display the client and server versions (``1.18.0`` and ``1.17.5``
respectively in the following example)::

    $ kubectl version
    Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.0", GitCommit:"9e991415386e4cf155a24b1da15becaa390438d8", GitTreeState:"clean", BuildDate:"2020-03-26T06:16:15Z", GoVersion:"go1.14", Compiler:"gc", Platform:"darwin/amd64"}
    Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.5", GitCommit:"e0fccafd69541e3750d460ba0f9743b90336f24f", GitTreeState:"clean", BuildDate:"2020-04-16T11:35:47Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}

.. _kubernetes instructions: https://kubernetes.io/docs/tasks/tools/install-kubectl/
