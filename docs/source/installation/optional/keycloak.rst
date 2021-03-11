########
Keycloak
########

`Keycloak`_ is an open source software product to allow single sign-on with
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

Fragalysis uses the library mozilla-django-oidc to authenticate with Keycloak.
(See: https://mozilla-django-oidc.readthedocs.io/en/stable/installation.html)

You will need to set up a different client in Keycloak for *every* environment
you have for your site - local, development, staging, production. This is so
that the callback urls can be correctly configured.

A minimal client configuration for the site: **fragalysis.some-company.com**,
in the Keycloak realm: **some-realm**, would need to contain:

On the *Settings* tab:

*   Client_id: *(Required)*
*   Client Protocol: *open-connect*
*   Valid Redirect URLs

    * https://fragalysis.some-company.com/oidc/callback/
    * http://fragalysis.some-company.com/oidc/callback/
    * http://fragalysis.some-company.com/viewer/react/landing

*   ID Token Signature Algorithm: *RS256*.

From the *Credentials* tab, the generated client-secret must be also noted
for inclusion in the Fragalysis environment parameters.

Parameter definitions for Keycloak are defined in
``roles/fragalysis-stack/defaults/main.yaml``. Look for variables that start
``stack_oidc_``.

Note that the realm parameter should contain the fully formed address of the
Keycloak server. For example::

    stack_oidc_keycloak_realm: https://keycloak.some-company.com/auth/realms/fragalysis

.. _keycloak: https://www.keycloak.org
