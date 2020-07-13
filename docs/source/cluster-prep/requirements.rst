**************************
Cluster Requirements (AWS)
**************************

The following _minimum_ (preliminary) cluster requirements will need to be
satisfied before the Fragalysis Stack can be deployed and used.

Control Machine
===============

1.  **Applications**. the control machine will need: -

    *   Python 3.8
    *   Git

2.  **GitHub**. In order to deploy the infrastructure the control
    machine will need access to GitHub where Ansible playbooks and roles are
    located, specifically: -

    * InformaticsMatters/ansible-infrastructure

3.  **Ansible Galaxy**. In order to configure the infrastructure
    AWX server the control machine will need access to
    `Ansible Galaxy <https://galaxy.ansible.com>`_

4.  **LENS**. `Lens`_ is respectable Kubernetes IDE. We use it to monitor
    our own clusters and, if you do not currently use a Kubernetes dashboard
    or IDE, you might want to use it too.

5.  **Credentials**. You will need credentials that allow admin privilege
    access to the cluster and, if using AWS S3 as the origin for graph fragment
    and Fragalysis Stack media data, a user with READ access for your chosen
    AWS S3 *bucket*.

Cluster
=======

1.  **Kubernetes Admin User**. The kubernetes cluster must provide a
    non-tokenised (non-expiring) user with cluster admin privileges. This
    is the user that the deployment playbooks will use to maintain the cluster.

2.  **An AWS IAM user** capable of reading from an AWS S3 bucket, used
    to provision frag ent graph and Frgalysis media data.

3.  **AWS S3**. The cluster must allow READ access to AWS S3 where fragment data
    for the neo4j graph database and loader (media) data for the Stacks is
    expected to reside. The bucket name can be configured during deployment.

    *   We can provide open-access to the existing Fragalysis Stack graph
        data but if you want to use your own fragment data you will need to
        ensure you publish it to a suitable bucket that can be accessed by
        the cluster.

4.  **One Application Node**. A compute instance with the following
    minimum specification: -

    *   8 cores
    *   32Gi RAM
    *   40Gi root volume
    *   Kubernetes node labels

        *   purpose=application

    *   Kubernetes node taints

        *   (none)

5.  **One Graph Node**. A compute instance with the following
    minimum specification: -

    *   8 cores
    *   >128Gi RAM
    *   40Gi root volume
    *   Kubernetes node labels

        *   purpose=bigmem

    *   Kubernetes node taints

        *   purpose=bigmem:NoSchedule

6.  **GitHub Access**. The cluster must allow access to Ansible playbooks
    and roles that are located on publicly accessible repositories on GitHub.
    The cluster must not be prevented from accessing these repositories. The
    current list of GitHub repositories is listed below: -

    *   InformaticsMatters/dls-fragalysis-stack-kubernetes
    *   InformaticsMatters/docker-neo4j-ansible


7.  **Hostnames**. You will need to provide routing to your cluster for at
    least two hostanmes, one for the fragalysis stack
    (i.e. ``frafalysis.example.com``) and one for the AWX server
    (i.e. ``awx.example.com``).

8.  **Networking (ingress)**. We deploy the `nginx`_ ingress controller
    as a **DaemonSet**, deployed to each compute instance. This acts as an
    internal load-balancer and routing service. It directs HTTPS traffic
    to the corresponding container (**Pod**).

9.  **Networking (load balancing)**. We need to load-balance traffic to
    the cluster. On AWS, rather than create a Application Load
    Balancer, which would normally result in a an ALB instance for each ingress,
    we create a ``LoadBalancer`` **Service**, which creates a single layer-4
    AWS Network Load Balancer (`NLB`_) for the entire cluster.

    If the use of an NLB is not acceptable and instead you want to use
    an ALB or your own load-balancing solution you will be
    responsible for its installation and management.

10. **Networking (certificates)**. The fragalysis stack is a web-based
    application that the user normally interacts with using a resolvable
    hostname, i.e. **fragalysis.example.com**.

    To simplify and streamline deployment, and avoid users having to
    provide their own certificates, our solution deploys the
    `cert-manager`_, a native Kubernetes certificate management controller.
    We use it to automatically issue and renew certificates to allow SSL (HTTPS)
    connection to the stack using `Let's Encrypt <https://letsencrypt.org/>`_.
    This relies on the certificate manager's ability to connect to the
    Let's Encrypt service.

    If this is not possible in your cluster and you need HTTPS connections to
    the stack you're deploying you will need to provide your own certificate
    solution.

.. _lens: https://k8slens.dev
.. _nginx: http://cnn.com/
.. _cert-manager: https://cert-manager.io/docs/
.. _nlb: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html
