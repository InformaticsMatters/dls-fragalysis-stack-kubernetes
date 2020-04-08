# AWX Configuration
The AWX server configuration files - `tower` map variables that describe
the desired initial state of the server. This relies on Ansible,
the tower-cli and Ansible Galaxy roles and collections.

From the project root (in a suitable environment): -

    $ pip install -r requirements.txt
    $ ansible-galaxy install -r requirements.yaml
    $ ansible-galaxy collection install -r requirements.yaml
    
    $ ansible localhost \
        -m include_role -a name=informaticsmatters.awx_composer \
        -e "@awx-configuration/config-demo.vault"
