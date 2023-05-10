To set new 'k8s (SELF)' AWX credentials: -

From a virtual environment: -

```
$ pip install --upgrade pip
$ pip install -r requirements.txt
$ ansible-galaxy collection install -r collection-requirements.yaml
```

1.  Create a `params.yaml` from the `params.yaml.template` and set suitable values
2.  Create a `tower_cli.cfg` from the `tower_cli.cfg.example` ans set suitable values

Then, run...

```
$ ansible-playbook -e @params.yaml site-awx-k8s-credentials.yaml
```
