*******************************
Developer Builds (Using Docker)
*******************************

.. epigraph::

    This is the simplest (often fastest) way to develop the stack - by
    building the Docker images locally and pushing them to a public registry
    like Docker Hub.

Edit your code, build the ``fragalysis-stack`` Docker image and push it.
You can then run the **Developer Fragalysis Stack** Job Template
to deploy that image to the cluster. You wil need to make sure the
template's variables are set accordingly (i.e. the image and tag you've
pushed)::

    stack_image (i.e. mynamespace/fragalysis-stack)
    stack_image_tag (i.e. `fix-1.2`)

..  toctree::
    :maxdepth: 1

    deployment
