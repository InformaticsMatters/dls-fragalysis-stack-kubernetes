########################
Removing the AWS cluster
########################

Once you're done with the cluster, using the ```cluster.yaml`` you used to
create it, you can delete it with the following command::

    eksctl delete cluster --name=fragalysis-production

Removal of the cluster will take around 10 minutes.
