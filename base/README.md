# S2I ODH NB Example

This repository can be used to build custom image for ODH jupyterhub.
Feel free to base your repository on this repo.

- Update [Pipfile](./Pipfile) for new package inclusion
- Update [Dockerfile](./Dockerfile) for any change with root permission on build time
- Update [assemble script](.s2i/bin/assemble) for any change with user permission on build time
- Update [run script](.s2i/bin/run) for any change with user permission on runtime


## Importing the Notebook

This image could be imported into an OpenShift cluster using OpenShift ImageStream:

```yaml
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  # (Below label is needed for Opendatahub.io/JupyterHub)
  # labels:
  #   opendatahub.io/notebook-image: "true"
  name: <image-name>
spec:
  lookupPolicy:
    local: true
  tags:
  - name: latest
    from:
      kind: DockerImage
      name: quay.io/thoth-station/<image-name>:latest
```

## Building the Notebook

[Dockerfile](./Dockerfile) is present on the root directory. Tools like `podman` or `docker` can be used for building.
