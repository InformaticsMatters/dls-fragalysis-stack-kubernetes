########################
Removing the AWS cluster
########################

Once you're done with the cluster, using the ```cluster.yaml`` you used to
create it, you can delete it with the following command::

    eksctl delete cluster -f cluster.yaml

Removal of the cluster will take around 10 minutes.
