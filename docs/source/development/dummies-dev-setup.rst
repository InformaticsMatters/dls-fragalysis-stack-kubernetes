################################################
Deploying your Stack ("Development for Dummies")
################################################

..  image:: ../images/fragalysis-development-for-dummies.png

This document goes through the deployment of a full developer stack.
It will show how to:

*   Set up the first instance of the developer stack
*   Clone the database and media from the production stack into your developer stack
*   Set GitHub `Actions`_ up to automatically push to your stack when
    changes are made to the master branch, using forks of the fragalysis repositories

***************
Getting started
***************

Forking from GitHub
===================

The fist step is to ensure that you have forked the master branch of each
component of the fragalysis stack:

1.	`xchem/fragalysis-backend <https://github.com/xchem/fragalysis-backend>`_
2.	`xchem/fragalysis-frontend <https://github.com/xchem/fragalysis-frontend>`_
3.	`xchem/fragalysis-loader <https://github.com/xchem/fragalysis-loader>`_
4.	`xchem/fragalysis-stack <https://github.com/xchem/fragalysis-stack>`_

Old forks should have the current version of master put in - changes to the
stack include changes to how CI/CD works, so it is important that all forks are
brought up-to-date with the master branch of the XChem repositories

Setting up with AWX
===================

The stack image for your development environment can be accessed at
https://awx-xchem.informaticsmatters.org/#/login [#f1]_.

Once you are logged in, you can find the templates for the jobs you can run
under **Templates** on the left-hand side of the page. For standard developers,
there are two kinds of jobs:

*   **Common [...]** - these jobs are for duplicating the database and
    media components into your own stack
*   **User [...]** - these jobs are for deploying or destroying the stack

If Rachael hasn't already run the first stack job for you, here's how to do it:

1. Run the **User (<name>) Developer Fragalysis Stack** job

    *   NB: **DO NOT** navigate to your stack URL
        until you have completed steps 2 and 3 below
    *   NB: the URL for your stack is spat out in the output of this job
    *   NB: you must be logged in as your own user to create your own stack.
        **DO NOT** run any other user's job under **any** circumstances

2. Run the **Common Database Replicator (One-Time)** job

    * NB: you must be logged in as your own user for this to populate your stack

3. Run the **Common Media Replicator (One-Time)** job

    * NB: you must be logged in as your own user for this to populate your stack

Each job can be launched by clicking on the rocket icon next to the template,
this will open the job template, and allow you to launch it.
For these first steps, it is fine to run the jobs without changing any parameters.

When the jobs are finished, navigate to the URL spat out by the job in
step **1** above. You should now have a copy of the stack that is created from the
``xchem/master`` branches.

***********************************
Setting up GitHub Actions for CI/CD
***********************************

In this deployment, we use GitHub `Actions`_ to run our CI/CD process.

Intro to how the CI/CD works
----------------------------

This is a cumbersome but worthwhile step. First of all, you should decide which
repositories you want to work on and fork them.

Once forked, you can configure GitHub Actions in your account to automatically
trigger builds when you push changes, and automatically deploy
your stack images from your own dockerhub account. The AWX job that
we set up earlier looks for the dockerhub stack image that you build and push,
based on variables that define the image ownership (namespace).
By default the AWX template job will assume the image _namespace_ is ``xchem``
and the image tag ``latest``, so the default image reference for the
Fragalysis Stack is ``xchem/fragalysis-stack:latest``.

You control each repository's CI/CD process using **Secrets** that you create
in your fork of the corresponding repository. The ``xchem`` repositories have
a set that builds the Stack correctly for them.

The quickest way to see what build variables are available, and what they do,
is to look at the repository's ``.github/workflows/build-main.yaml`` file.
The comments at the top of the file describes its variables in detail.

Here, I'll list all the variables that can be added for each deployment.
The backend, frontend and loader configurations are optional, depending on what
repository you want to work on. However, you should configure your stack
variables if you want to automatically push to your live deployment when you
push changes to a branch (I'd suggest setting this up just for ``master``)

Adding (Secrets) to a GitHub repository
---------------------------------------

1.  Log in to GitGub
2.  Navigate to the repository fork you've made
3.  Click on Settings
4.  Click on Secrets in the left-hand panel
5.  Add the relevant secrets (described below) as a **New repository secret**

Fragalysis GitHub secrets
=========================

Backend variables (secrets)
---------------------------

Variables related to images (Dockerhub):

*   ``DOCKERHUB_USERNAME`` - Dockerhub username to allow you to push
*   ``DOCKERHUB_TOKEN`` - Dockerhub user access token to allow you to push
*   ``BE_NAMESPACE`` - the Dockerhub namespace you want to push to
    (e.g. ``reskyner`` if you're pushing to ``reskyner/fragalysis-backend``)

If you set ``TRIGGER_DOWNSTREAM`` (to ``yes``) a successful build of the
backend will trigger a build of the corresponding stack,
using the following optional variables: -

*   ``FE_NAMESPACE`` - the namespace of the frontend you'll want in your Stack image
    (e.g. ``reskyner`` if you're expecting to use ``reskyner/fragalysis-frontend``)
*   ``FE_BRANCH`` - the frontend repository branch you'll want in your Stack image
    (e.g. ``main`` if you're expecting to use ``main``)
*   ``STACK_NAMESPACE`` - the namespace of the stack you expect to be built
    (e.g. ``reskyner`` if you're expecting to use ``reskyner/fragalysis-stack``)
*   ``STACK_BRANCH`` - the stack branch you want to build
    (e.g. ``main`` if you're expecting to use ``main``)

You will need to define the following, a user and GitHub `personal access token`_
that can trigger the Stack build: -

Variables related to GitHub fragalysis-stack repo: -

*   ``STACK_USER`` - GitHub user for stack
*   ``STACK_USER_TOKEN`` - GitHub user token

Optional (have defaults): -

*   ``BE_IMAGE_TAG`` (default = latest) (dockerhub if not latest)

Frontend variables (secrets)
----------------------------

Variables related to automated build:

*   ``TRIGGER_DOWNSTREAM`` - ``yes`` to trigger build of the stack

Variables related to GitHub fragalysis-stack repo:

*   ``STACK_USER`` - GitHub user for stack
*   ``STACK_USER_TOKEN`` - GitHub user token

Variables related to images (Dockerhub):

*   ``BE_NAMESPACE`` - docker namespace for the backend (default xchem)
*   ``BE_IMAGE_TAG`` - docker tag for the backend (default latest)

Variables related to frontend GitHub repo:

*   ``FE_NAMESPACE`` – front-end namespace to use in the stack
*   ``FE_BRANCH`` - front-end branch

Variables related to stack GitHub repo:

*   ``STACK_NAMESPACE`` – stack namespace to trigger
*   ``STACK_BRANCH`` - stack branch to trigger

Stack variables (Mandatory for automated builds)
------------------------------------------------

Variables related to stack image - the one your stack will use (Dockerhub):

*   ``DOCKERHUB_USERNAME`` - dockerhub username to allow push
*   ``DOCKERHUB_TOKEN`` - dockerhub password to allow push
*   ``STACK_NAMESPACE`` - the Dockerhub namespace you want to push to
    (e.g. ``reskyner`` if you're pushing to ``reskyner/fragalysis-stack``)

Variables setting which back-end image to use
(optional - ``will default to xchem/master``):

*   ``BE_NAMESPACE`` - the Dockerhub namespace you want to use
    (e.g. ``reskyner`` if you're using ``reskyner/fragalysis-backend``)
*   ``BE_IMAGE_TAG`` - docker image tag (optional, will default to ``:latest``)

Recommended set-up for front-end developers
===========================================

1. Fork the ``xchem/fragalysis-frontend`` repo from GitHub
2. Fork the ``xchem/fragalysis-stack`` repo from GitHub
4. Setup the following GutHub repository secrets for the front-end GitHub Actions: -

    * Secrets related to triggering the stack::

        TRIGGER_DOWNSTREAM = yes
        STACK_USER
        STACK_USER_TOKEN

    * Variables related to frontend GitHub repo::

        FE_NAMESPACE = <your GitHub account name here>
        FE_BRANCH = master

    * Variables related to stack GitHub repo (that you've forked)::

        STACK_NAMESPACE = <your GitHub account name here>
        STACK_BRANCH = master

5. Setup the following GitHub secrets for the stack you've forked:

    * Variables related to stack image - the one your stack will use (Dockerhub)::

        DOCKERHUB_USERNAME
        DOCKERHUB_TOKEN

Now that you've done this, every time you push a change from a branch
into ``master`` in your frontend fork:

*   The tests for the front-end will run as a GitHub Action
*   If the tests pass, the stack CI/CD will be triggered
*   When the stack-job completes, an image of that stack will be pushed to your Dockerhub repo
    that you can use in your AWX Job Template

Alternative deployment strategy - Developing locally
====================================================

On the ``xchem/fragalysis-backend`` and ``xchem/fragalysis-frontend``
repositories, there are instructions on how to set up a local development
environment using Docker in the ``README.md`` files in the root of the
respective repository.

Part of the process of using this local environment includes building the
backend and/or frontend images, and using them locally, and then using those
images to build a stack image Because the stack image is all that is needed
to push a new version into a live stack, the following process can be used to
use those locally built images to push to your stack on AWX:

1.  log in to docker::

    $ docker login --username=<your hub username> --password=<your password>

2.  Build your image by executing the docker build command. ``DOCKER_ACC``
    is the name of your account, ``DOCKER_REPO`` is your image name
    and ``IMG_TAG`` is your tag::

    $ docker build -t $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG .

    e.g. ``docker build -t reskyner/fragalysis-stack:latest .``
    is the command for rachael to build her stack image, ready to push do
    dockerhub.

3.  Now, you can push this image to your hub by executing the docker push command::

    $ sudo docker push $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG

    This will push the image up to dockerhub. The only image you need to push
    is the stack image, as this is the image used by AWX to build your stack.

4.  Go to AWX, and navigate to your **User (<name>) Developer Fragalysis Stack (Version Change)**
    job template

5.  In the ``EXTRA VARIABLES`` section, change ``stack_image: xchem/fragalysis-stack``
    to point to your image (e.g. ``reskyner/fragalysis-stack``)

6.  Save and launch the job

7.  Navigate to the stack to see the changes from your local dev environment
    live in the wild!

.. _dockerhub: https://hub.docker.com
.. _actions: https://github.com/features/actions
.. _personal access token: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

.. rubric:: Footnotes

.. [#f1] Rachael (rachael.skyner@diamond.ac.uk) will give you your username
         and password to log in
