################################################
Deploying your Stack ("Development for Dummies")
################################################

..  image:: ../images/fragalysis-development-for-dummies.png

This document goes through the deployment of a full developer stack.
It will show how to:

*   Set up the first instance of the developer stack
*   Clone the database and media from the production stack into your developer stack
*   Set Travis up to automatically push to your stack when changes are made to
    the master branch on your forks of the fragalysis repositories

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

***************************
Setting up Travis for CI/CD
***************************

In this deployment, we use Travis to do CI/CD, rather than Travis for CI,
and Jenkins for CD. It's much easier to customise
how your stack is built by using Travis.

Prerequisites
=============

*   You have a `travis`_ account
*   You have added your forks to your Travis account
*   You have a Travis api-token
*   You have a `dockerhub`_ account

Using the right Travis version
==============================

The CI/CD implementation will only work running from the newest version of
Travis, which is now found at https://travis-ci.com/. However, to set this up
correctly, you will need to start from https://travis-ci.org/.

1.  Log in to https://travis-ci.org/ with your github account
2.  On the left-hand side of the first page that loads, under your user account,
    there will be a **request beta access** button - click it.
3.  This will take you to https://travis-ci.com/
4.  If you are using an organisation account (e.g. xchem) then you will need
    to request access and grant it from github

Once you have granted access to Travis, your repositories should appear
in the dashboard of Travis

Getting a Travis API token
--------------------------
The following should give you an API access token::

    $ gem install travis && travis login --com && travis token --com

Keep it safe - we need it to allow us to trigger builds for automated deployment.

Intro to how the CI/CD works
----------------------------

This is a cubersome but worthwhile step. First of all, you should decide which
codebases you want to work on, and therefore incorporated changes from into
your own stack.

Once you have decided, you can set up your Travis jobs to automatically
trigger builds when you push to certain branches, and automatically deploy
your stack or component images to your own dockerhub account. The AWX job that
we set up earlier looks for the dockerhub stack image that you build and push
with Travis, by taking a single variable, which is the endpoint for your stack
image. e.g. ``rachael/fragalysis-stack``. The stack job template assumes it
is always looking for the stack image tagged as ``:latest`` at that endpoint.

The quickest way to see what the different build variables are, and what they do,
is to look at the ``.travis.yml`` file in each repository. The comments at
the top of those files describe the variables in detail.

Here, I'll list all the variables that can be added for each deployment.
The backend, frontend and loader configurations are optional, depending on what
code-base you want to work on. However, you should configure your stack
variables if you want to automatically push to your live deployment when you
push changes to a branch (I'd suggest setting this up just for ``master``)

Adding variables to Travis
--------------------------

1.  Log in to Travis
2.  Navigate to the Travis job on the left-hand side
    (it will appear there after you add them)
3.  Click on the burger menu
4.  Click on the Settings option
5.  Add the relevant options under **Environment variables** -
    make sure to not show any sensitive info in the build logs

Travis environment variable descriptions
========================================

Backend variables (Optional)
----------------------------

Variables related to images (Dockerhub):

*   ``PUBLISH_IMAGES`` - set this to yes to push any built image to docker
*   ``DOCKER_USERNAME`` - Dockerhub username to allow you to push
*   ``DOCKER_PASSWORD`` - Dockerhub password to allow you to push
*   ``BE_NAMESPACE`` - the Dockerhub namespace you want to push to
    (e.g. ``reskyner`` if you're pushing to ``reskyner/fragalysis-backend``)

Variables related to GitHub fragalysis-stack repo:

*   ``STACK_NAMESPACE`` - GitHub user for stack
*   ``STACK_BRANCH`` - Github user branch for stack

Variables related to auto-triggerring stack build:

*   ``TRAVIS_ACCESS_TOKEN`` - your Travis access token
*   ``TRIGGER_DOWNSTREAM`` - set to ``yes`` to trigger a stack build when
    back-end build is successful

Optional (have defaults):

*   ``BE_IMAGE_TAG`` (default = latest) (dockerhub if not latest)
*   ``LOADER_NAMESPACE`` - xchem (unless working on loader)
*   ``LOADER_BRANCH`` - master (unless working on loader)

Frontend variables (Optional)
-----------------------------

Variables related to automated build (Travis):

*   ``TRIGGER_DOWNSTREAM`` - yes to trigger build of stack & loader
*   ``TRAVIS_ACCESS_TOKEN`` - needed for the trigger

Variables related to images (Dockerhub):

*   ``BE_NAMESPACE`` - docker namespace (default xchem)

Variables related to frontend GitHub repo:

*   ``FE_NAMESPACE`` – front-end user/account
*   ``FE_BRANCH`` - branch

Variables related to stack GitHub repo:

*   ``STACK_NAMESPACE`` – stack user/account
*   ``STACK_BRANCH`` - GitHub user/account branch

Loader variables (Optional)
-----------------------------

Variables related to loader image (Dockerhub):

*   ``PUBLISH_IMAGES`` - yes to push to docker
*   ``DOCKER_USERNAME`` - dockerhubb username
*   ``DOCKER_PASSWORD`` - dockerhub password
*   ``LOADER_NAMESPACE`` - the Dockerhub namespace you want to push to
    (e.g. ``reskyner`` if you're pushing to ``reskyner/loader``)

Variables to decide which backend image to use when building the loader image
(optional - will default to ``xchem/master``):

*   ``BE_NAMESPACE`` - the Dockerhub namespace you want to use
    (e.g. ``reskyner`` if you're using ``reskyner/loader``)
*   ``BE_IMAGE_TAG`` – version of image to use
    (optional, will default to ``:latest``)

Stack variables (Mandatory for automated builds)
------------------------------------------------

Variables related to stack image - the one your stack will use (Dockerhub):

*   ``PUBLISH_IMAGES`` - yes to push to docker
*   ``DOCKER_USERNAME`` - dockerhub username to allow push
*   ``DOCKER_PASSWORD`` - dockerhub password to allow push
*   ``PUBLISH_IMAGES`` - yes to push to docker - make sure to change
    ``STACK_NAMESPACE`` to push to own docker hub account
*   ``STACK_NAMESPACE`` - the Dockerhub namespace you want to push to
    (e.g. ``reskyner`` if you're pushing to ``reskyner/fragalysis-stack``)

Variables setting which back-end image to use
(optional - ``will default to xchem/master``):

*   ``BE_NAMESPACE`` - the Dockerhub namespace you want to use
    (e.g. ``reskyner`` if you're using ``reskyner/fragalysis-stack``)
*   ``BE_IMAGE_TAG`` - docker image tag (optional, will default to ``:latest``)

Variables to control automatic pushing to your AWX stack:

*   ``AWX_HOST`` - AWX url (for devs: https://awx-xchem.informaticsmatters.org/)
*   ``AWX_USER`` - AWX username provided by Rachael
*   ``AWX_USER_PASSWORD`` - AWX password provided by Rachael
*   ``TRIGGER_AWX`` – yes to push to AWX
*   ``AWX_DEV_JOB_NAME`` - name of the developer AWX job to trigger stack auto build:

    * NB: As the Job Name contains spaces it needs to be placed between
      double quotes, e.g. ``"User (Rachael) Developer Fragalysis Stack (Version Change)"``.
      This should be done with any variable value that contains spaces.
    * NB: Change the name to your name!

Recommended set-up for front-end developers
===========================================

1. Fork the ``xchem/fragalysis-frontend`` repo from GitHub
2. Fortk the ``xchem/fragalysis-stack`` repo from GitHub
3. Add your forks to Travis
4. Setup the following environment variables for the front-end Travis jobs:

    * Variables related to automated build (Travis)::

        TRIGGER_DOWNSTREAM = yes
        TRAVIS_ACCESS_TOKEN = <your access token here>

    * Variables related to frontend GitHub repo::

        FE_NAMESPACE = <your GitHub account name here>
        FE_BRANCH = master

    * Variables related to stack GitHub repo::

        STACK_NAMESPACE = <your GitHub account name here>
        STACK_BRANCH = master

5. Setup the following environment variables for the stack Travis jobs:

    * Variables related to stack image - the one your stack will use (Dockerhub)::

        PUBLISH_IMAGES = yes
        DOCKER_USERNAME = <Your dockerhub username here>
        DOCKER_PASSWORD = <Your dockerhub password here>
        PUBLISH_IMAGES = yes
        STACK_NAMESPACE = <your GitHub account name here>

    * Variables setting which back-end image to use
      (optional as it will default to ``xchem/master``)::

        BE_NAMESPACE = <Your dockerhub username here>

    * Variables to control automatic pushing to your AWX stack::

        AWX_HOST = https://awx-xchem.informaticsmatters.org/
        AWX_USER = <Your AWX username here>
        AWX_USER_PASSWORD = <Your AWX password here>
        TRIGGER_AWX = yes
        AWX_DEV_JOB_NAME = "User (<Your name here>) Developer Fragalysis Stack (Version Change)"

6. Alter the **User (<Your name here>) Developer Fragalysis Stack (Version Change)** job in AWX:

    * Click on the templates on the left hand side
    * Click on the job name
    * Under ``EXTRA VARIABLES`` change ``stack_image: xchem/fragalysis-stack``
      to point to your image (e.g. ``reskyner/fragalysis-stack``)

Now that you've done this, every time you push a change from a branch
into ``master`` in your frontend fork:

*   The tests for the front-end will run in Travis
*   If the tests run, the back-end and stack jobs will be triggered
*   When the stack-job completes, an image of that stack will be pushed to your Dockerhub repo
*   After the image is pushed, a job is triggered in AWX
*   That job takes the image that has just been pushed and re-builds the stack with it

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
.. _travis: https://travis-ci.com

.. rubric:: Footnotes

.. [#f1] Rachael (rachael.skyner@diamond.ac.uk) will give you your username
         and password to log in
