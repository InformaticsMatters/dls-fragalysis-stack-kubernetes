# Rancher
Material to configure the RKE-based xchem Rancher deployment.

Here we rely on a Kubernetes cluster based on instances created in the
`xchem-follow-up` STFC project.

-   Currently the instances are created using the **OpenStack** console
    (multiple etcd, single control-plane and worker instances)
-   **RKE** is used to deploy Kubernetes to the compute instances
    using a simple `cluster.yml` configuration file (enclosed) - as
    described on the Rancher site
-   **Rancher** is installed using the same, official, documentation

This repository is cloned on the **xchem-follow-up** project's bastion
node (`xch-bastion`) in Alan's account under `git/dls-fragalysis-stack-kubernetes`.
Run everything from `git/dls-fragalysis-stack-kubernetes/rancher`

The following steps are performed on the project's bastion node (`xch-bastion`).

Essentially, the high-level stages consist of...

1.  Cluster preparation
2.  Install rke
3.  Install kubectl
4.  Install helm
5.  Prepare for AWS S3 etcd backups
6.  Creating compute instances and a matched `cluster.yml`
7.  Install Kubernetes (using rke)
8.  Install rancher (using helm)

At the time of writing the RKE cluster is using: -

-   kubernetes `v1.19.9`
-   Rancher `v2.5.7`

>   We're not using a load-balancer, just workers and control plane
    with a public IP address attached.

>   Setup a hostname pointing to the IP address you expect to be using
    on the worker node (remember to leave enough time for the routing
    to resolve to the application node).

### Installing rke
Follow the instructions at [installing rke] to install `rke`

    $ wget https://github.com/rancher/rke/releases/download/v1.2.7/rke_linux-amd64
    $ mv rke_linux-amd64 rke
    $ chmod a+x rke

After which you should be able to run: -

    $ rke --version
    rke version 1.2.7

#### Restoring the cluster RKE state file
If you need to restore the RKE cluster state file you can run the following: -

    $ rke util get-state-file

This should re-generate the files...

    cluster.rkestate
    kube_config_cluster.yml

### Installing kubectl
Follow instructions at [installing kubectl] to install the `kubectl` client: -

    $ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    $ chmod a+x kubectl

...after which you should be able to run: -

    $ kubectl version --client --short
    Client Version: v1.21.0
    
>   Ensure you are using kubectl 1.18 or better.

### Installing helm
For a detailed reference refer to the [installing Helm] documentation.
Helm now has an installer script that will automatically grab the latest
version of Helm and install it locally: -

    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh

    $ helm version

### Prepare for AWS S3 etcd backups
We backup the RKE cluster to AWS S3 via settings in the `cluster.yml`.
To do this you need a _bucket_, a _folder_ in the bucket and suitable
AWS credentials.

**IMPORTANT** The xch-bastion `cluster.yml` file **MUST NOT be committed back to
revision control - it contains sensitive AWS credentials.

### Creating compute instances
At STFC we have provided a cluster-prep playbook that configures a base machine image
that should be used for any new nodes for the RKE cluster. See the
`site-rke-machine` playbook in `rancher/cluster-prep/ansible-machine-prep`.

Given a base machine on STFC (and a jump host (i..e the xch-bastion) you should be able to
run the `site-rke-machine.yaml` playbook to initialise the base image. This has already
been done and so does not need to be done again unless you want a new base image.

The current machine image snapshot is: -

-  `rke-k8s-base-ubuntu-docker-20.10.24`.

The base image contains: -

-   Docker 10.20.24
-   NFS client
-   A Docker Hub mirror
-   An /etc/noquattor file to avoid automated updates

If you need to create a new base image...

From the `cluster-prep/ansible-machine-prep` directory: -

```bash
$ python -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ ansible-galaxy install -r requirements.yaml
```

>   If you provide a `/etc/hosts/` file on the bastion with the IP of the machine to be
    configured (with an IP address for the name `rke-ii-base`) you should be able to use
    the inventory "as is"

With a suitable machine running and the account user's name that can be used used
for SSH access to the machine, run: -

```bash
$ ansible -m ping all
$ MACHINE_USER=abc1234 ansible-playbook site-rke-machine.yaml
```

Once configured you should snapshot the machine so the image can be used
as the base for any new machines in your RKE cluster.

We create instances using the STFC OpenStack console. We create 3
**etcd** nodes, dual control plane nodes and one or more worker nodes.

Instances details: -

-   **etcd** is `l3.nano` (2-core 8Gi RAM)
-   **control plane** is `l3.nano` (2-core 8Gi RAM)
-   **worker** is `l3.micro` (4-core 16Gi RAM)
-   Base image for all is the image created above

>   The control-plane and worker have publicly-accessible Floating IPs attached
    and it's these IPs that are used in the `cluster.yml` we create for
    installing **rke**.

### Install Kubernetes (using rke)
Create the `cluster.yml` and then install Kubernetes...

    $ cd ${HOME}/rke
    $ rke up
    [...]
    INFO[0321] Finished building Kubernetes cluster successfully 
    $ export KUBECONFIG=${HOME}/git/dls-fragalysis-stack-kubernetes/rancher/kube_config_cluster.yml
    $ kubectl get no
    NAME             STATUS   ROLES          AGE    VERSION
    130.246.215.43   Ready    controlplane   3m6s   v1.17.5
    130.246.215.45   Ready    worker         3m5s   v1.17.5
    192.168.253.14   Ready    etcd           3m5s   v1.17.5
    192.168.253.30   Ready    etcd           3m5s   v1.17.5
    192.168.253.47   Ready    etcd           3m4s   v1.17.5

>   As we've used a public IP for the control-plane the generated
    `kube_config_cluster.yml` should be useful outside the
    STFC cluster.

#### Adding worker nodes
You can add new worker nodes by editing the `cluster.yml`, ensuring you've run
the `site-rke` playbook in our `ansible-infratstructure` project and then
using `rke`: -

    $ rke up --update-only

For details refer to the [update] documentation.

### Install rancher (using helm)
As we have direct access to the Internet from the cluster
we can follow the main [install Rancher] instructions, which is
basically the following...

-   Add the Helm chart repository
-   Create a namespace for Rancher
-   Choose your SSL configuration
-   Install cert-manager
-   Install Rancher with Helm and your chosen certificate option
-   Verify that the Rancher server is successfully deployed

Simplified (for our specific needs) into the following instructions: -

    $ helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
    $ kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
    $ kubectl create namespace cert-manager
    $ helm repo add jetstack https://charts.jetstack.io
    $ helm repo update
    $ helm install \
          cert-manager jetstack/cert-manager \
          --namespace cert-manager \
          --version v0.12.0
      
 Check (and wait for) the certificate manger....

    $ kubectl get pods --namespace cert-manager

Install and wait for rancher...

    $ kubectl create namespace cattle-system
    $ helm install rancher rancher-stable/rancher \
      --namespace cattle-system \
      --version=2.3.11 \
      --set hostname=rancher-xchem.informaticsmatters.org
    $ kubectl -n cattle-system rollout status deploy/rancher

### Set the initial Rancher admin password
Now connect to the Rancher console at `rancher-xchem.informaticsmatters.org`
(relatively quickly) so that we can check the installation and, more
importantly, set the initial administrator password
(which we keep in our KeePass instance under
**Rancher -> Admin User (XCHEM/STFC)**.

You can reset the password for the `admin` user by shelling into a Rancher Pod
and running reset-password: -

    $ kubectl exec --stdin --tty -n cattle-system <Pod> -- /bin/bash
    # reset-password
    [...]
    wAOdxMNux5EY4sbWLTJn
    # exit

---

[installing rke]: https://rancher.com/docs/rke/latest/en/installation/#download-the-rke-binary
[installing kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[installing helm]: https://helm.sh/docs/intro/install/
[install rancher]: https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/helm-rancher/
[update]: https://rancher.com/docs/rke/latest/en/managing-clusters/
