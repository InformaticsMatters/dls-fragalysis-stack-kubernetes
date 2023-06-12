#################
Exposing new Jobs
#################

Jobs are defined by Job Definitions in Squonk. It is the role of the administrator
of the Squonk site to load job definitions into the service. It is beyond the realm
of this documentation to describe the process of defining and then adding Jobs to Squonk
but you can read the `Creating new Jobs`_ documentation on the Data Manager **Pages**
site.

For jobs that are already available in Squonk, to expose them in fragalysis, you will
need to provide a new ``override`` file and **POST** this to the Fragalysis
``/api/job_override`` endpoint.

The override contains three essential sections: ``global``, ``precompilation_ignore``
and specific overrides for each supported Job in the ``fragalysis-jobs`` list.

.. _Creating new Jobs: https://informaticsmatters.gitlab.io/squonk2-data-manager/1-1/creating-new-jobs.html

The global section
==================

**TBD**

The precompilation_ignore section
=================================

**TBD**

The fragalysis-jobs section
===========================

The ``fragalysis-jobs`` section contains a list of jobs that are supported by Fragalysis.
The job is identified using its name, version and collection using the properties: -

* ``job_name``
* ``job_version``
* ``job_collection``
        
Following this the override provides "over-rides" for the Job's control variables,
which the developer provides in the ``inputs``, ``options`` and ``outputs`` sections.
These setting allow the front-end to attach Fragalysis specific variables onto the Job.
