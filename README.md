# Volume Tool

Simple file manager for use in docker and especially with openshift/kubernetes persistent volumes.

## Features

* connect via webdav client (courtesy of [caddy-webdav](https://github.com/mholt/caddy-webdav))
* view and manage files (courtesy of [filebrowser](https://filebrowser.org/features))
* image previews
* in-browser text/code editor
* drag-and-drop file organizing
* file upload and download
* in-browser terminal

## Unsupported

This image is expected to be used locally, or with a sidecar or reverse proxy server. Do not expose this container directly to the internet as-is.

Missing features:

* authentication (could be configured in `Caddyfile`)
* HTTPS (could be configured in `Caddyfile`)

## Docker Examples

    # build/run local example sharing repo directory on port 8080 
    docker compose up app
    
    # share home directory as current user on http://localhost:8080
    docker run -d \
      -u `id -u` \
      -v "$HOME":/data \
      -p 8080:8080 \
      kevineye/volume-tool 

## Openshift Examples

    # replace NAME_OF_PVC with volume to access
    oc run volume-tool --image unused --restart Never \
      --overrides '{"spec": {"containers": [ { "name": "volume-tool", "image": "kevineye/volume-tool",
        "resources": { "limits": { "cpu": "100m", "memory": "64Mi" }, "requests": { "cpu": "50m", "memory": "32Mi" } },
        "volumeMounts": [{ "mountPath": "/data", "name": "volume" }]
        }], "volumes": [ { "name": "volume", "persistentVolumeClaim": { "claimName": "NAME_OF_PVC" } } ] }}'
    
    # privately expose via port forwarding (much safer than a public route)
    oc port-forward volume-tool 8080
    open http://localhost:8080
    
    # cleanup
    oc delete pod volume-tool
