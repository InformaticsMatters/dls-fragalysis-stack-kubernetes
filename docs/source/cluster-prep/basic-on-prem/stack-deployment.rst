###################
Deploying the Stack
###################

.. note:: Allow **45 minutes** to complete this task.
          5 minutes for the stack and 40 minutes
          for the initial (``ALL_TARGETS``) data load.

With the graph installed we can now start the Fragalysis Stack and its
*Data Loader*.

The playbooks that we'd normally run from AWX can be executed form the
command line. That's what we'll be doing here.

The steps we'll follow here are: -

*   Clone the Fragalysis Kubernetes playbook repository (this repo)
*   Create a parameter file to satisfy your cluster
*   Run the stack installation playbook
*   Run the stack loader

********************
Clone the stack repo
********************

The repository contains playbooks and roles for the deployment of
the **stack**, its **loader** and more. From your virtual environment
clone it and (ideally) switch to the most recent tag::

    $ git clone https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes
    $ cd dls-fragalysis-stack-kubernetes
    $ git checkout tags/2020.51

**********************
Create parameter files
**********************

The Stack and its loader are controlled by a number of Ansible variables.
To control your deployment you are likely to have to
define your own set of variable values in *parameter* files - not all of
those that are set in the repo may be of use to you.

You wil probably want to create separate parameter files for the stack
playbook and its loader: -

*   ``parameter-stack.yaml``
*   ``parameter-loader.yaml``

There are a lot of playbooks and roles so we have not (as yet) provided any
examples but a typical set that you need to set for the **stack**
are as follows::

    ---
    all_image_preset_pullsecret_name: ''

    stack_hostname: example.com
    stack_sa_psp: im-core-unrestricted
    stack_image_registry: docker.io
    stack_image_tag: latest
    stack_replicas: 2
    stack_include_sensitive: no
    stack_namespace: fragalysis-production
    stack_is_for_developer: no
    stack_media_vol_storageclass: efs

    busybox_image_registry: docker.io

    database_vol_storageclass: gp2

    graph_hostname: graph.graph.svc
    graph_password: (the password you used for the graph deployment)

Also, create a set of variables to control the stack **loader**::

    ---
    all_image_preset_pullsecret_name: ''

    loader_type: s3
    loader_data_origin: 2020-09-15T16
    loader_s3_bucket_name: im-fragalysis
    loader_s3_image_registry: docker.io
    loader_s3_image: informaticsmatters/fragalysis-s3-loader
    loader_s3_image_tag: 1.0.7-2
    loader_include_sensitive: no

    stack_is_for_developer: no
    stack_namespace: fragalysis-production

**********************
Run the stack playbook
**********************

With a set of parameters created, deploy the Stack using the
``site-fragalysis-stack.yaml`` playbook::

    $ ansible-playbook -e @parameter-stack.yaml site-fragalysis-stack.yaml
    [...]

The stack consists (mainly) of a namespace, a Fragalysis Stack **StatefulSet**,
and a postgres database that it uses. The stack deployment waits for the
Graph before it completes initialisation so you must have previously installed
the graph before you deploy any stacks.

Use ``kubectl`` or **Lens** to make sure the stack the database are running
before trying to run the loader.

*****************************
Run the stack loader playbook
*****************************

You can't use the stack without any target data so you now need to run
the *Data Loader*.

Run the loader (assuming you;ve setup or have access to a suitable AWS S3
bucket and data) playbook::

    $ ansible-playbook -e @parameter-loader.yaml site-data-loader.yaml
    [...]

This playbook will wait for the loader to complete. If you're loading
a typical **ALL_TARGETS** load this will take around 40 minutes to complete.
The playbook will time-out after an hour.

Once complete you should be able to navigate to the application by navigating
to the URL you used for ``stack_hostname``.
