############################
New Branch Policy (Nov 2022)
############################

.. epigraph::

    The new branch and build policy introduced November 2022.

****
Why?
****

Prior to this we were building production stacks from frontend branches and
backend latest images. This is error-prone. Between the time taken to decide
to create a production image and actually creating one a new backend latest
stack could have been pushed or the frontend's branch could have changed.

By using tags from backend and frontend...

#.  We create a much more reliable and repeatable build process
#.  We have a clear reference to the underlying code for defect tracking

By using a staging branch in the backend and frontend we are able to safely
collect all the changes for the next release separately from the existing
production branch.

This allows us to make hot-fixes directly on or on branches created from the
current production branch without the risk of polluting the production release
with lots of other changes which are now confined to the staging branch

By using multiple "integration branches" (i.e. `yellow` and `blue`),
created from the staging branch, we are able to work on features that are
scheduled for different production releases simultaneously

.. epigraph::

    A little bit of extra work for increased reliability and traceability

*********************
Branch and tag policy
*********************

There are two **PERMANENT** (**protected**) branches in the backend repository.
A ``staging`` branch and a ``production`` branch.

You will also find one or more **integration** branches, used to integrate the
features for an active major/minor release. These might be used for milestones
and the naming is to be declared but it could be the milestone ``ms-2022-08-18``
or a more friendly name like the designated colour that's referred to during
meetings (``yellow``, ``purple``). So, if code for ms-2022-08-18 (yellow) is
being actively developed you might expect to find a ``yellow`` integration
branch.

Developers implement features (or fix bugs) on **feature** branches.

GitHub Actions result in new container images for: -

*   For every commit to a **feature**/**integration** branch
    (tagged using the branch name slug, i.e. yellow)
*   For every commit to the ``staging`` branch (tagged using latest)
*   For every non-production tag/release on the ``staging`` branch
*   For every production tag/release on the ``production`` branch

Summarised in the diagram below: -

..  image:: ../images/branch-topology-nov-2022/fragalysis-branch-topology.001.png

Automated stack builds
======================

For every change to either the ``staging`` or ``production`` branch on the
**backend** (or **frontend**), a GitHub workflow Action triggers a build of the
**stack** image (in its repository) using the image just built in the backend.

Stack images built this way are launched by a user running a suitable
AWX Ansible Job Template.

As illustrated in the diagram below: -

..  image:: ../images/branch-topology-nov-2022/fragalysis-branch-topology.004.png

Control variables
=================

For all this to work the **backend** repository needs access to a number of
control variables defined either as a GitHub Repository (or Organisational)
Secret or as part of a GitHub Environment.

.. epigraph::

    Refer to the build staging workflow for details of the expected variables
    and their expected origin (Secret or Environment).

To trigger a downstream build of the **stack** for example you will need to
define the following Secrets: -

*   ``TRIGGER_DOWNSTREAM`` (set to "yes")
*   ``STACK_USER``
    (A GitHub user account that build the stack)
*   ``STACK_USER_TOKEN``
    (A suitable "personal access token" for thew stack user account)
