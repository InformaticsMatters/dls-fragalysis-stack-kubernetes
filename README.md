# Flexible playbooks for Fragalysis-Stack (Kubernetes)

![yamllint and doc build](https://github.com/InformaticsMatters/dls-fragalysis-stack-kubernetes/workflows/lint%20and%20doc%20build/badge.svg)

[![Documentation Status](https://readthedocs.org/projects/im-dls-fragalysis-stack-kubernetes/badge/?version=latest)](https://im-dls-fragalysis-stack-kubernetes.readthedocs.io/en/latest/?badge=latest)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/informaticsmatters/dls-fragalysis-stack-kubernetes)

[![CodeFactor](https://www.codefactor.io/repository/github/informaticsmatters/dls-fragalysis-stack-kubernetes/badge/master)](https://www.codefactor.io/repository/github/informaticsmatters/dls-fragalysis-stack-kubernetes/overview/master)

Ansible Playbooks (and Roles) for the deployment of the XChem [Fragalysis Stack]
application to Kubernetes. This repository builds on the work accomplished
by our [OpenShift deployment] and yields plays that can be run from an [AWX]
server.

## Preparation
You'll need a Python environment where you need to install the project
requirements (for Python and Ansible): -

    python -m venv ~/.venv/dls-fragalysis-stack-kubernetes
    source ~/.venv/dls-fragalysis-stack-kubernetes/bin/activate
    
    pip install --upgrade pip
    pip install -r requirements.txt
    ansible-galaxy install -r requirements.yaml --force
    ansible-galaxy collection install -r collection-requirements.yaml --force

Create a service account (and access token), that can be used to manufacture `KUBECONFIG` files providing users (and AWX) access to the cluster.
This is a one-off task.

See the README in `cluster-prep`.

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
which results in the main index page `docs/build/html/index.html`,
run the following from the project root: -

    pip install -r build-requirements.txt
    sphinx-build -Eab html docs/source docs/build/html

The project documentation is also published to [Read The Docs],
where you can find pre-compiled copies online.
 
---

[awx]: https://github.com/ansible/awx
[fragalysis stack]: https://github.com/xchem/fragalysis-stack
[openshift deployment]: https://github.com/InformaticsMatters/dls-fragalysis-stack-openshift
[read the docs]: https://im-dls-fragalysis-stack-kubernetes.readthedocs.io/en/stable/
[sphinx]: https://pypi.org/project/Sphinx/
[notes]: https://raw.githubusercontent.com/InformaticsMatters/okd-orchestrator/master/README-SPHINX.md
