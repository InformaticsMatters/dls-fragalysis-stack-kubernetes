########################
Removing the AWS cluster
########################

Once you're done with the cluster, using the ``cluster.yaml`` you used to
create it, you can delete it ans all the installed kubernetes objects
with the following command::

    eksctl delete cluster -f cluster.yaml

Removal of the cluster will take around 10 minutes.

When done you should inspect the AWS resources to ensure nothing is left behind.
You might have a VPC, Subnets or Load Balancer that may need removing.
