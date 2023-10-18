########################
Updating the stack image
########################

.. note::
    Here, as with we did when deploying the stack, we rely on Ansible playbooks that are
    provided in the the Informatics Matters `dls-fragalysis-stack-kubernetes`_ repository.

With the stack deployed and running, you can now update the stack image.
To do this, you need to build a new image and push it to the Docker
container registry. With this done edit the ``parameters.yaml`` file
you used to install the stack and provide a new ``<IMAGE-TAG>``::

    ---
    stack_image_tag: <PRODUCTION-TAG>

Now you can run the *slightly faster* update playbook, where you will need the
repository vault secret::

    ansible-playbook site-fragalysis-stack_version-change.yaml -e @parameters.yaml \
        --ask-vault-password

.. _dls-fragalysis-stack-kubernetes: https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes
