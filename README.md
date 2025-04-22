# eopf-toolkit-jupterhub-k8s

The initial setup of the JupyterHub k8s cluster was done by following the JupyterHub for Kubernetes documentation here: https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html

# Steps Carried Out:

## Created a new namespace

`eopf-tooklit-dev` with `resources/0-eopf-toolkit-namespace.yml`

## Installed the JupyterHub Helm Chart

```
helm upgrade --cleanup-on-fail \
  --install 0.0.1 jupyterhub/jupyterhub \
  --namespace eopf-toolkit-dev \
  --version=4.2.0 \
  --values config.yaml \
  --kubeconfig=kubeconfig.yml
```

## Created a .ds.io record

Service is now available at eopf-toolkit-dev.ds.io

## Enabled HTTPS with LetsEncrypt

Updated `config.yaml` with:

```
proxy:
  https:
    enabled: true
    hosts:
      - eopf-toolkit-dev.ds.io
    letsencrypt:
      contactEmail: ciaran@developmentseed.org
```

And applied changes:

```
helm upgrade --kubeconfig=kubeconfig.yml --cleanup-on-fail \
  0.0.1 jupyterhub/jupyterhub \
  --namespace eopf-toolkit-dev \
  --version=4.2.0 \
  --values config.yaml
```

## Added Github OAuth access

Firstly created a new Github OAuth application within the `eopf-toolkit` org

Updated `config.yaml` with:

```
hub:
  config:
    GitHubOAuthenticator:
      client_id: <id>
      client_secret: <secret>
      oauth_callback_url: https://eopf-toolkit-dev.ds.io/hub/oauth_callback
    JupyterHub:
      authenticator_class: github
```

Run:

```
helm upgrade --kubeconfig=kubeconfig.yml --cleanup-on-fail \
  0.0.1 jupyterhub/jupyterhub \
  --namespace eopf-toolkit-dev \
  --version=4.2.0 \
  --values config.yaml
```

## Limit to `eopf-toolkit` org for OAuth

Modified config.yaml with:

```
allowed_organizations:
  - my-github-organization
scope:
  - read:org
```

In the `GitHubOAuthenticator` block, then ran:

```
helm upgrade --kubeconfig=kubeconfig.yml --cleanup-on-fail \
  0.0.1 jupyterhub/jupyterhub \
  --namespace eopf-toolkit-dev \
  --version=4.2.0 \
  --values config.yaml
```

## Made Ciaran an admin user

Updated `hub.config.Authenticator` with:

```
admin_users:
  - ciaransweet
```

Ran:

```
helm upgrade --kubeconfig=kubeconfig.yml --cleanup-on-fail \
  0.0.1 jupyterhub/jupyterhub \
  --namespace eopf-toolkit-dev \
  --version=4.2.0 \
  --values config.yaml
```
