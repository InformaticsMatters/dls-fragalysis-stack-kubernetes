################################
Moving relocated stack data back
################################

Once you're done with the cluster, and you want to return data to the original stack
(which we assume is still operational), you'll need to backup the the database
and copy the media directory.

The following brief instructions illustrate the process.

With a ``KUBECONFIG`` environment variable set for the *relocated* cluster,
enter the stack **Pod** and copy the media directory to a new S3 bucket.
You'l need to install the ``awscli`` package in the **Pod** to do this.

    kubectl exec -it stack-0 -n production-stack -- bash
    pip install awscli
    export AWS_ACCESS_KEY_ID=000000
    export AWS_SECRET_ACCESS_KEY=00000000
    export AWS_DEFAULT_REGION=eu-west-2
    aws s3 cp \
        /code/media \
        s3://im-fragalysis/aws-production-stack-media/ \
        --recursive

This will take 20 to 30 minutes.

When done, exit the shell and stop the stack by spinning down the **StatefulSet**
replica count to zero::

    kubectl scale statefulset --replicas=0 stack -n production-stack

Then enter the database Pod to generate a backup of the ``frag`` database (you don't
need a full backup)::

    kubectl exec -it database-0 -n production-stack -- bash
    pg_dump --username=admin frag | gzip > /tmp/frag.sql.gz

Exit the **Pod** and copy the backup to your local machine::

    kubectl cp database-0:/tmp/frag.sql.gz ./aws-stack-frag.sql.gz -n production-stack

Now set ``KUBECONFIG`` for the original stack, in your original cluster
and recover the database and media.

First scale down the original stack::

    kubectl scale statefulset --replicas=0 stack -n production-stack

Copy the database backup from your local machine to the original database **Pod**::

    kubectl cp ./aws-stack-frag.sql.gz database-0:/tmp/frag.sql.gz -n production-stack

Then enter the **Pod** and wipe (drop and recreate) and recover the ``frag`` database::

    kubectl exec -it database-0 -n production-stack -- bash
    psql --username=admin template1 -c 'drop database frag;'
    psql --username=admin template1 -c 'create database frag with owner fragalysis;'
    gzip -d /tmp/frag.sql.gz
    psql --username=admin frag < /tmp/frag.sql

Start the stack **Pod** again::

    kubectl scale statefulset --replicas=1 stack -n production-stack

The enter the Pod and restore the media directory from the S3 bucket you just created::

    kubectl exec -it stack-0 -n production-stack -- bash
    pip install awscli
    export AWS_ACCESS_KEY_ID=000000
    export AWS_SECRET_ACCESS_KEY=00000000
    export AWS_DEFAULT_REGION=eu-west-2
    aws s3 cp \
        s3://im-fragalysis/aws-production-stack-media/ \
        /code/media \
        --recursive

The original stack state should now match the relocated stack.
