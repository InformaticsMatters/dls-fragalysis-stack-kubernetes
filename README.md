# Flexible playbooks for Fragalysis-Stack (Kubernetes)

[![Build Status](https://travis-ci.com/InformaticsMatters/dls-fragalysis-stack-kubernetes.svg?branch=master)](https://travis-ci.com/InformaticsMatters/dls-fragalysis-stack-kubernetes)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/informaticsmatters/dls-fragalysis-stack-kubernetes)

Ansible Playbooks (and Roles) for the deployment of the XChem [Fragalysis Stack]
application to Kubernetes. This repository builds on the work accomplished
by our [OpenShift deployment] and yields plays that can be run from an [AWX]
server.

## Preparation
You'll need a Python environment where you need to install the project
requirements (for Python and Ansible): -

    conda activate dls-fragalysis-stack-kubernetes
    pip install -r requirements.txt
    ansible-galaxy install -r requirements.yaml --force
    ansible-galaxy collection install -r collection-requirements.yaml --force

## Configuring the AWX server
To setup the AWX server for a specific cluster refer to the `README`
in the `awx-configuration` directory.

## Editing the sensitive.vault
Certain, sensitive, variables are located in the encrypted file
`roles/fragalysis-stack/vars/sensitive.vault`. This file should not be
committed un-encrypted and can be edited from the project root without 
decrypting it, armed with the repository vault password, using: -

    ansible-vault edit roles/fragalysis-stack/vars/sensitive.vault

## Project documentation
The documentation is written in [Sphinx]. To build the documentation
(from within an environment that satisfied `build-requirements.txt`),
which results in the main index page `docs/build/html/index.html`,
run the following from the project root: -

    sphinx-build -Eab html docs/source docs/build/html

---

[awx]: https://github.com/ansible/awx
[fragalysis stack]: https://github.com/xchem/fragalysis-stack.git
[openshift deployment]: https://github.com/InformaticsMatters/dls-fragalysis-stack-openshift.git
[sphinx]: https://pypi.org/project/Sphinx/
[notes]: https://raw.githubusercontent.com/InformaticsMatters/okd-orchestrator/master/README-SPHINX.md
