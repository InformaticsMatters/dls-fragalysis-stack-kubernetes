*************
Rancher setup
*************

We are using a very simple Rancher setup, running as a container on an AWS EC2
instance. Documentation relating to its setup and configuration
can be found in the following external (GoogleDoc) document: -

#.  `Creating clusters with Rancher`_ (AWS)

With the following relevant sections: -

*   Before you start
    *   Create an S3 bucket for etcd backups
    *   Create an AWS IAM User
    *   Create an AWS IAM Role
*   Deploy Rancher (“quickstart”)
*   Set the Rancher server URL
*   Create Cloud Credentials
*   Create Node Templates

..  toctree::
    :maxdepth: 2
    :caption: Creating clusters

    rancher-cluster-ec2
    rancher-cluster-eks

.. _Creating clusters with Rancher: https://docs.google.com/document/d/1cplrJouWcO_6FRRMv32wFwQb7eTC2ZqyuMYi0v8CWU8/edit?usp=sharing
