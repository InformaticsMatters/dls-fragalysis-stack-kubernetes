###################################
A Developer Cheat-Sheet for kubectl
###################################

.. epigraph::

    Some useful ``kubectl`` commands.
    This is only a *taster** of common commands, you can also refer to the
    official `Kubernetes Cheat Sheet`_ for many more.

Setting the default namespace
    To quickly restrict your commands to a given namespace, e.g.
    your own Fragalysis Stack deployment you can use the **set-context**
    command. If your stack is deployed to **stack-alan-default** you can set the
    default namespace to it with the following command: -

    ``$ kubectl config set-context --current --namespace=stack-alan-default``

    From this point forward you need to add ``-n stack-alan-default`` to each
    command you want to run.

    This is probably the most important command to you should run - by setting
    the default namespace to that for your stack it'll be much more difficult
    for you to make the mistake of adjusting the content of namespaces
    being used by others.

    The following *cheats* assume that you have set the default namespace.

List namespace content
    You can see all the (typical)objects in a namespace with the following
    command: -

    ``$ kubectl get all``

    It'll display information about **Pods**, **Services**, **Jobs**,
    **CronJobs**, **Deployments** and **StatefulSets**. Ironically **all**
    doesn't show you everything.

List more namespace content (PVCs, Secrets, Ingress)
    You can display information about any object in a namespace as long as you
    know what it is you want to see. Some common objects not present in the
    default set of *all* objects are volume claims (a **pvc**), secrets
    and external ingress paths. You can use recognised abbreviations or the
    full object name: -

    ``$ kubectl get pvc``

    ``$ kubectl get svc``

    ``$ kubectl get service``

    ``$ kubectl get ing``

    Or combine them: -

    ``$ kubectl get pvc,svc,ing``

Display Pod logs
    Kubernetes keeps the stdout of each container in a Pod. The term Pod
    is implied when using the command so you simply need to provide the name
    of the Pod, you don't have to tell Kubernetes it's a Pod: -

    ``$ kubectl logs stack-0``

    You can *follow* logs: -

    ``$ kubectl logs stack-0 -f``

    You can see the logs from the last 10 minutes, or the last 10 lines: -

    ``$ kubectl logs stack-0 --since=10m``

    ``$ kubectl logs stack-0 --tail=10``

    You can see the logs from the previous container instance, if it exists
    (in the case of a restarted container): -

    ``$ kubectl logs stack-0 -p``

Shell into a Pod container
    You can get an interactive container shell in a Pod assuming you know what
    shell the container is sing (typically **bash**). To get into a running
    Fragalysis Stack you can use this command: -

    ``$ kubectl exec -it pod/stack-0 bash``

    Once you're done you can **ctrl-d** to get out of the container.

Port-forwarding
    You can access Pod ports from your local machine using the
    ``kubectl port-forward`` command. For example, if you have a database
    Pod (``database-0``) using port ``5432`` in namespace ``blob``
    you can connect ``1234`` on your local machine to the Pod with...

    ``kubectl port-forward database-0 -n blob 1234:5432``

    Then, any local access to port ``1234`` will be redirected to the
    Pod.

Watching object state changes
    You can watch rolling update status of the stack until completion
    using the ``--watch`` argument

Restarting a Pod (scale down and up)
    You can *bounce* (restart) a container. This won't normally re-deploy a
    new image - for that you really need to be using the AWX console.
    But the following might be useful if you simply want to restart a Pod,
    which is achieved by scaling down and then back up. Here we scale down
    the Stack's **StatefulSet** before scaling it bak up again.

    Remember that restarting a Pod will cause it to loose any data
    that is not actively persisted.

    ``$ kubectl scale --replicas=0 statefulset/stack``

    ``$ kubectl scale --replicas=1 statefulset/stack``

.. _kubernetes cheat sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

