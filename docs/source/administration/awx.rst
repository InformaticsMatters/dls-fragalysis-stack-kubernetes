#######################
AWX (Adding Developers)
#######################

Before a developer con deploy their Fragalysis Stack
they will need a user account on the Development AWX sever
and Jobs duplicated and assigned to them.

************
Adding Users
************

Using an administrative account on the Development AWX server navigate to
**Users** in the side-panel and click the **+** (Add) icon in the
upper-right-hand corner.

*   Provide suitable values for all the fields.
*   Most **USER TYPE** values a likely to be **Normal User**
*   Click **Save**

Now you need to assign permissions and duplicate Job templates.
The user will only see templates that you assign to them, as described
below.

*************************************
Permissions and Duplicating Templates
*************************************

Now that you've created a user navigate to the **Templates** panel using the
side-bar. Here we need to provide access to common Jobs and duplicate Jobs we
expect the developer to edit for the User you've just added.

Common Templates
================

Here we give users access to each template that begins with the word
**Common**. For each **Common** template: -

*   Click it to navigate to it
*   Click the **PERMISSIONS** button at the top of the panel
*   Click the **+** (Add) icon to add a user
*   Click the empty checkbox next to the appropriate user from the dialogue box
    that appears
*   In the **Please assign roles to the selected users/teams** section
    select the **Execute** role - the user needs to execute common Jobs
    but is not expected to edit them.
*   Click **Save**

Developer-specific Templates
============================

Here we need to Duplicate each template that begins **Developer**. For each
**Developer** template: -

*   Click the **Copy Job Template** at the end of the template row
*   The template is duplicated initially by by adding the text ``*<HH:MM:SS>``
    to the end of the new template name, Click this new template name to
    edit it
*   Change the duplicated template's **NAME** by removing the ``*<HH:MM:SS``
    from the end and add ``User (<user>)`` at the beginning.
*   Click the **PERMISSIONS** button at the top of the panel
*   Click the **+** (Add) icon to add the user to the template
*   In the **Please assign roles to the selected users/teams** section
    select the **Admin** role - the user needs to be able to edit and execute
    the developer Jobs.
*   Click **Save**

**********************************************
Provide the Development Kubernetes Config file
**********************************************

Developers will need a kubernetes configuration file in order to
interact with the cluster. Ideally each developer will need a config file
that has a kubernetes user created specifically for them, or you can share a
common configuration.

*   Create a user on Rancher (and export the kubeconfig)
*   Or circulate the generic ``config-xchem-development-developer`` configuration

****************
Here Be Dragons!
****************

DO NOT
    ...circulate a cluster ``*-admin`` configuration or
    ``*-diamond`` configuration outside of the Diamond organisation.

DO NOT
    ...run job templates in the development cluster designed for other users.
    The developer and common templates are *conscious* of the logged-in user
    and, as the stack namespaces are automatically generated based on the
    **username** running another user's job as will have unexpected
    and potentially damaging side-effects.

    Only run developer and common jobs when you're logged-in as a developer
    account, never as an administrator.

    This excludes the **Graph** deployment - these jobs can be run by anyone
    who has permissions - it's namespaces is fixed.