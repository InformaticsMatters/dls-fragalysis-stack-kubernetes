#################
Important Secrets
#################

A number of Fragalysis Stack repositories rely on a number of *secrets*
(generally account usernames and passwords and tokens) that need to be
defined for the code build and deployments to work. The most significant
of which are identified here.

Before reading further it's worth understanding the documentation for
GitHub's **organisational**, **environment** and **repository** secrets,
which can be found in their `encrypted secrets`_ guide.

******
GitHub
******

Repositories that *trigger* the execution of downstream repositories rely on
a GitHub username and a `personal access token`_. These values are often
defined in each repository that needs them as **repository** secrets.

- ``STACK_USER``
- ``STACK_USER_TOKEN``

Repositories that trigger other repositories are ``fragalysis-frontend`` and
``fragalysis-backend``.

..  note::

    ``LOADER_`` variables relate to the legacy loader repository and its build.
    These are no longer used and can be removed.

*********
DockerHub
*********

Repositories that publish public container images rely on a DockerHub
user account (and `access token`_). At the moment this is defined as a pair of
**organisational** secrets in the ``xchem`` GitHub account, automatically
available to all ``xchem`` repositories: -

- ``DOCKERHUB_USERNAME``
- ``DOCKERHUB_TOKEN``

****
PyPi
****

The ``fragalysis`` repository relies on the following **repository** secrets
to allow it to push Python packages to PyPI: -

- ``PYPI_APIKEY``

******************
Deployment Secrets
******************

A number of secrets are passed to the stack image through its environment
at run-time in Kubernetes. The following secrets, of particular importance,
because they may be related to accounts of "real" users, will be held/defined
in the AWX server.

- ``ISPYB_USER``
- ``ISPYB_PASSWORD``
- ``SSH_USER``
- ``SSH_PASSWORD``

.. _access token: https://docs.docker.com/docker-hub/access-tokens
.. _encrypted secrets: https://docs.github.com/en/actions/security-guides/encrypted-secrets
.. _personal access token: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
