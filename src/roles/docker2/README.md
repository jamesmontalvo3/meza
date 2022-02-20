FITBox role to setup Docker and Docker-Compose on CentOS
========================================================

**This, like all or most FITBox roles, is a public repository and no sensitive or otherwise non-public information is permitted**

This role sets up Docker and Docker Compose, but does not make use of them.

Install
-------

Add the following to your FITBox `local.yml`:

```yaml
fitbox_roles:
  # ... other roles ...

  - name: docker
    repo: https://gitlab.fit.nasa.gov/fitbox/role-docker.git
    version: "tags/x.y.z" # Specify an actual version
```

Some notes about the above config:

1. This role should be added to `fitbox_roles` along with any other roles you need
2. The version was set to `tags/x.y.z`. This is not a real tag. Go to [role-docker releases](https://gitlab.fit.nasa.gov/fitbox/role-docker/-/releases) to find the latest version. You could also specify a branch, like `master`, but then you risk your servers unexpectedly changing when this repo changes.

