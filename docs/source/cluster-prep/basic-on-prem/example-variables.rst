###############################
Example sets of variables (AWS)
###############################

If you're deploying the graph and stack *on-prem* the following sets of
example variables provide a basic set of minimal values that you might want
to use. [#f1]_.

The following also assumes that your images [#f2]_ are hosted on a private
*registry* (``artifactrepo.xzy.com/docker.io`` in these snippets) and you
have created a *pull secret* called ``secret-artifactory`` in namespaces that
you've pre-allocated.

Infrastructure
==============

You could run the infrastructure playbook with the following: -

.. code-block:: yaml

    cm_state: absent
    cinder_state: absent
    efs_state: absent
    nfs_state: absent
    infra_state: absent

Graph
=====

You could run the graph playbook with the following: -

.. code-block:: yaml

    graph_password: -SetMe-

    graph_loader_image: informaticsmatters/neo4j-s3-loader
    graph_image: informaticsmatters/neo4j
    graph_tag: '3.5.20'

    graph_volume_size_g: 800
    graph_pvc_storage_class: gp2
    graph_bucket: im-fragnet
    graph_bucket_path: combination/3
    graph_wipe: no

    graph_pagecache_size_g: 80
    graph_mem_request_g: 96

    wait_for_bind: no

    graph_image_registry: artifactrepo.xzy.com/docker.io
    all_image_preset_pullsecret_name: secret-artifactory


Stack
=====

You could run the stack playbook with the following: -

.. code-block:: yaml

    stack_image: xchem/fragalysis-stack
    stack_image_tag: '2.0.5'
    stack_is_for_developer: false

    stack_media_vol_size_g: 12
    stack_media_vol_storageclass: <YOUR EFS STORAGE CLASS NAME>
    stack_namespace: fragalysis-production
    stack_replicas: 2
    stack_include_sensitive: no
    database_vol_storageclass: gp2

    graph_hostname: graph.graph.svc
    graph_password: <THE SAME ONE YOU USED TO DEPLOY THE GRAPH>

    stack_cert_issuer: ''

    stack_hostname: fragalysis.xyz.com
    # Registries
    stack_image_registry: artifactrepo.xzy.com/docker.io
    database_image_registry: artifactrepo.xzy.com/docker.io
    busybox_image_registry: artifactrepo.xzy.com/docker.io
    # Pull secret name
    all_image_preset_pullsecret_name: secret-artifactory

Loader
======

You could run the loader playbook with the following: -

.. code-block:: yaml

    loader_s3_bucket_name: im-fragalysis
    loader_data_origin: 2020-09-15T16
    loader_type: s3
    loader_s3_image: xchem/fragalysis-s3-loader
    loader_s3_image_tag: '2.0.5'
    loader_include_sensitive: no

    stack_is_for_developer: false
    stack_namespace: fragalysis-production

    # Registries
    loader_s3_image_registry: artifactrepo.xzy.com/docker.io
    # Pull secret name
    all_image_preset_pullsecret_name: secret-artifactory

.. rubric:: Footnotes

.. [#f1] These would be suitable for a site where you've provided your own
         *infrastructure* (i.e. nginx and EFS) but are using our *core*,
         i.e. our Pod Security Policy and have access to graph and stack data
         on an S3 bucket.

.. [#f2] The image names used here are for illustrative purposes only.
         If in doubt, ask us for a set of up-to-date images and tags.
