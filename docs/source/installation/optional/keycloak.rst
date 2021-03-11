########
Keycloak
########

Keycloak is an open source software product to allow single sign-on with
Identity and Access Management aimed at modern applications and services.
The Fragalysis Stack can be configured to authenticate and authorise access
through Keycloak.

************
Installation
************

You can skip this section if you have your own Keycloak server - this section
deals with installing Keycloak using our Infrastructure.

You can deploy Keycloak using our Infrastructure. It will install a
Keycloak service and supporting PostgreSQL database into your cluster.
If you do not have your own server you can follow our guide:
:doc:`../basic/infrastructure-installation`.

*   These instructions assume you're using **Keycloak 10**
    or a version that's compatible.

Configuration
=============

Follow our guide:
:doc:`../basic/infrastructure-installation`.

*******************************
Post-installation configuration
*******************************

With Keycloak installed you now need to login, using the admin user
and password you used in the installation steps above, and configure
the running server.
