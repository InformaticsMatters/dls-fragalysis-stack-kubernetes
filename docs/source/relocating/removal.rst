########################
Removing the AWS cluster
########################

Once you're done with the cluster, using the ``cluster.yaml`` you used to
create it, you can delete it ans all the installed kubernetes objects
with the following command (which uses the ``--disable-nodegroup-eviction``
option to avoid being blocked because EBS add-ons have been installed)::

    eksctl delete cluster -f cluster.yaml --disable-nodegroup-eviction

Removal of the cluster will take around 10 minutes and hopefully it will
end with a message like::

    2023-11-07 21:07:22 [✔]  all cluster resources were deleted

When done you should still inspect the AWS resources to ensure nothing is left behind.
You might have a VPC, Subnets or Load Balancer that may need removing.
