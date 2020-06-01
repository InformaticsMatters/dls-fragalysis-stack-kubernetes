# AWX Configuration
The AWX server configuration files for use with the [AWX Composer] Ansible
Galaxy Role.

These vault files, one for each cluster, configure an AWX instance
for that cluster. For example, `config-xchem-developer` is intended to be used
with the developer cluster.

>   The `config-demo` file is used for demonstrations.

Each vault contains a `tower` map variable that describes
the desired initial state of the corresponding AWX server, relying on
Ansible, the tower-cli and Ansible Galaxy roles and collections.

## Preparation
You **MUST** provide AWS credentials (typically allowing AWS S3
bucket access to plays that operate with S3) and Kubernetes credentials.
You will need to set the following environment variables prior to running
Ansible: -

-   `AWS_ACCESS_KEY_ID`
-   `AWS_SECRET_ACCESS_KEY`
-   `K8S_AUTH_HOST` (i.e. `https://1.2.3.4:6443`)
-   `K8S_AUTH_API_KEY` (i.e. `kubeconfig-user-xvgfv.a-abcde:0000000000000`)

## Configuring AWX
There is an AWX server deployed to each cluster. The credentials are different
as is the configuration. The production and developer AWX servers will have
different Projects, Job Templates and Users - all configured via separate
configuration, encrypted with different vault passwords.

Armed with the appropriate configuration's vault key, from the project root,
first check your _encrypted_ developer cluster configuration is as required: -

    $ CONFIG_NAME=xchem-developer
    $ ansible-vault edit awx-configuration/config-$CONFIG_NAME.vault

And then configure the AWX server for the developer cluster by running
the following, providing the vault password when prompted: -

    $ ansible localhost \
        -m include_role -a name=informaticsmatters.awx_composer \
        -e @awx-configuration/config-$CONFIG_NAME.vault \
        --ask-vault-pass

---

[awx composer]: https://github.com/InformaticsMatters/ansible-role-awx-composer
