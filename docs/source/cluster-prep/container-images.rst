######################
Container Images (AWS)
######################

For a production deployment of the XChem Fragalysis Stack the following list
of container images are normally deployed to the AWS EKS Kubernetes
cluster [#f1]_. The images are used for the deployments of the **core**
services (Infrastructure and Fragalysis Stack) and optional areas that cover
**Backup and Recovery** and **Keycloak**.

..  epigraph::

    While we try to maintain the accuracy of this list some versions
    may change as development continues, this will most likely affect the
    version of the Fragalysis Stack as this image is likely to incur regular
    revision updates as the Stack's development is a continuous and
    on-going process. Most other images are unlikely to change often.

*******************
Infrastructure Core
*******************

These images provide certificate generation, the NGINX ingress controller
and an AWS EFS volume provisioner.

+-------------------------------------------------------------------+---------------+
| Container Image                                                   | Tag           |
+===================================================================+===============+
| docker.io/jettech/kube-webhook-certgen                            | v1.2.0        |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-cainjector                          | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-controller                          | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-webhook                             | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/kubernetes-ingress-controller/nginx-ingress-controller    | 0.33.0        |
+-------------------------------------------------------------------+---------------+
| quay.io/external_storage/efs-provisioner                          | v2.4.0        |
+-------------------------------------------------------------------+---------------+

**********************************
Infrastructure Database (Optional)
**********************************

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| docker.io/library/postgres            | 12.2          |
+---------------------------------------+---------------+

*******************
Keycloak (optional)
*******************

If installing Keycloak, you must install the Infrastructure Database.

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| docker.io/jboss/keycloak              | 11.0.0        |
+---------------------------------------+---------------+

*****************************
Infrastructure AWX (Optional)
*****************************

If installing AWX, you must install the Infrastructure Database.

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| docker.io/ansible/awx                 | 13.0.0        |
| docker.io/library/redis               | latest        |
| docker.io/library/centos              | 7             |
+---------------------------------------+---------------+

****************
Fragalysis Stack
****************

These images are required for a named (tagged) production Fragalysis Stack,
its own database and S3 data loader. The stack also requires a
fragmentation database, provided by a specialised neo4j image.

+---------------------------------------------------+-----------+
| Container Image                                   | Tag       |
+===================================================+===========+
| docker.io/library/busybox                         | 1.28.0    |
+---------------------------------------------------+-----------+
| docker.io/library/postgres                        | 12.2      |
+---------------------------------------------------+-----------+
| docker.io/xchem/fragalysis-stack                  | 1.0.7     |
+---------------------------------------------------+-----------+
| docker.io/informaticsmatters/fragalysis-s3-loader | 1.0.7-2   |
+---------------------------------------------------+-----------+
| docker.io/informaticsmatters/neo4j                | 3.5.20-1  |
+---------------------------------------------------+-----------+
| docker.io/informaticsmatters/neo4j-s3-loader      | 3.5.20-1  |
+---------------------------------------------------+-----------+

******************************
Backup and Recovery (optional)
******************************

+-------------------------------------------+---------------+
| Container Image                           | Tag           |
+===========================================+===============+
| docker.io/informaticsmatters/sql-backup   | 2020.4        |
+-------------------------------------------+---------------+
| docker.io/informaticsmatters/sql-recovery | 2020.4        |
+-------------------------------------------+---------------+

.. rubric:: Footnotes

.. [#f1] This list does not cover container images that would normally be
         considered part of Kubernetes.
