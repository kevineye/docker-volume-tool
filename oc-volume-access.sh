#!/bin/bash -e

if [ -z "$1" ]; then
  echo "usage: $0 <pvc-name>"
  exit 1
fi

function finish {
  echo
  echo "--> cleaning up"
  kill %1
  oc delete --wait pod volume-tool
  echo "--> finished"
}
trap finish EXIT

echo "--> starting volume-tool pod"
oc run volume-tool --image unused --restart Never \
  --overrides '{"spec": {"containers": [ { "name": "volume-tool", "image": "kevineye/volume-tool",
    "resources": { "limits": { "cpu": "100m", "memory": "64Mi" }, "requests": { "cpu": "50m", "memory": "32Mi" } },
    "volumeMounts": [{ "mountPath": "/data", "name": "volume" }]
    }], "volumes": [ { "name": "volume", "persistentVolumeClaim": { "claimName": "'"$1"'" } } ] }}'

echo "--> waiting for volume-tool to start"
oc wait --for condition=ready pod volume-tool

echo "--> setting up port forwarding"
oc port-forward volume-tool 8080 &

sleep 5

echo "--> opening http://localhost:8080"
echo "--> or use http://localhost:8080 for webdav"
open http://localhost:8080

echo "--> ctrl-c to exit and clean up"
wait %1
