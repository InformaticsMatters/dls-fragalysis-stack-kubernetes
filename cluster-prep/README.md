# Cluster Admin
Here we provide initial (day-1) configuration of the
cluster. Importantly this covers the creation of an **admin** service
account and token that can be used for administrative control of the
clusters and is intended to be circulated.

>   By using a custom service account wee can revoke the token in the future
    if it's been compromised by simply deleting and recreating the service account.

The admins service account consists of: -

- A Namespace
- A ServiceAccount
- A ClusterRoleBinding (binding the ServiceAccount to the cluster-admin ClusterRole)

Using a suitable `KUBECONFIG`, which provides ypu with cluster admin,
deploy the admin objects...

```bash
$ export KUBECONFIG=~/k8s-config/kubeconfig.yaml
$ kubectl apply -f cluster-admin.yaml
```

Once the SA is created you can then get its token...

```bash
$ ADMIN_NAME=im-k8s-admin
$ SECRET_NAME=$(kubectl get serviceaccount $ADMIN_NAME \
    -n $ADMIN_NAME -o jsonpath='{$.secrets[0].name}')
$ kubectl get secret ${SECRET_NAME} \
    -n $ADMIN_NAME -o jsonpath='{$.data.token}' | base64 -d | sed $'s/$/\\\n/g'
```

And then place this token in a suitable KUBECONFIG file...

```yaml
- name: "im-k8s-admin"
  user:
    token: 00000000000
```
