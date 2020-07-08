**********************
Container Images (AWS)
**********************

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

Core (Infrastructure)
=====================

+-------------------------------------------------------------------+---------------+
| Container Image                                                   | Tag           |
+===================================================================+===============+
| ansible/awx                                                       | 13.0.0        |
+-------------------------------------------------------------------+---------------+
| jettech/kube-webhook-certgen                                      | v1.2.0        |
+-------------------------------------------------------------------+---------------+
| postgres                                                          | 12.2          |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-cainjector                          | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-controller                          | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/jetstack/cert-manager-webhook                             | v0.12.0       |
+-------------------------------------------------------------------+---------------+
| quay.io/kubernetes-ingress-controller/nginx-ingress-controller    | 0.33.0        |
+-------------------------------------------------------------------+---------------+

Core (Fragalysis Stack)
=======================

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| busybox                               | 1.28.0        |
+---------------------------------------+---------------+
| informaticsmatters/neo4j              | 3.5           |
+---------------------------------------+---------------+
| informaticsmatters/neo4j-s3-loader    | 3.5           |
+---------------------------------------+---------------+
| postgres                              | 12.2          |
+---------------------------------------+---------------+
| xchem/fragalysis-stack                | 1.0.4         |
+---------------------------------------+---------------+
| xchem/fragalysis-s3-loader            | 1.0.4         |
+---------------------------------------+---------------+

Backup and Recovery (optional)
==============================

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| informaticsmatters/sql-backup         | 2020.4        |
+---------------------------------------+---------------+
| informaticsmatters/sql-recovery       | 2020.4        |
+---------------------------------------+---------------+

Keycloak (optional)
===================

+---------------------------------------+---------------+
| Container Image                       | Tag           |
+=======================================+===============+
| jboss/keycloak                        | 10.0.2        |
+---------------------------------------+---------------+

.. rubric:: Footnotes

.. [#f1] This list does not cover container images that would normally be
         considered part of Kubernetes.
