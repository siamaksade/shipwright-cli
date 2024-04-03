### Tekton Tasks for Shipwright

This task performs operations on Shipwright Builds using the CLI [`shp`](https://github.com/shipwright-io/cli).

## Install the Task

```bash
oc apply -f https://raw.githubusercontent.com/siamaksade/shipwright-cli/tekton/task.yaml
```


## Parameters

| name      | description                                 | default                                      |
| --------- | ------------------------------------------- | ---------------------------------------------|
| SHP_IMAGE | `shp` CLI container image to run this task. | `quay.io/siamaksade/shipwright-cli:latest`   |
| ARGS      | The arguments to pass to the `shp` CLI.     | `--help`                                     |
| SCRIPT    | `shp` CLI script to execute                 | `shp \$@`                                    |

## Workspaces

- **kubeconfig**: An [optional workspace](https://github.com/tektoncd/pipeline/blob/main/docs/workspaces.md#using-workspaces-in-tasks) that allows you to provide a `.kube/config` file for `shp` to access the cluster. The file should be placed at the root of the Workspace with name `kubeconfig`.

## Usage

1. Passing only `ARGS`

```yaml
  tasks:
    - name: build
      taskRef:
        kind: Task
        name: shp
      params:
        - name: ARGS
            value:  
            - build 
            - run 
            - $(params.BUILD_NAME)
            - --follow

```

2. Passing `SCRIPT` and `ARGS` and `WORKSPACE`

```yaml
  tasks:
    - name: build
      params:
        - name: SCRIPT
          value:  |
            shp build run $(params.BUILD_NAME) --follow
      taskRef:
        kind: Task
        name: shp
      workspaces:
        - name: kubeconfig
            secret:
                secretName: kubeconfig-secret
```

## Try It Out

* Create a project
```bash
$ oc new-project demo
```

* Create a Shipwright Build
```bash
$ shp build create sample-s2i-nodejs \
    --source-url="https://github.com/shipwright-io/sample-nodejs" \
    --source-context-dir="source-build" \
    --strategy-name="source-to-image" \
    --builder-image="image-registry.openshift-image-registry.svc:5000/openshift/nodejs:16-ubi8" \
    --output-image="image-registry.openshift-image-registry.svc:5000/demo/sample-nodejs" 
```

* Create the Shipwright CLI Task
```bash
$ oc apply -f tekton/task.yaml
```

* Create a sample pipeline that uses the Shipwright CLI Task
```bash
$ oc apply -f tekton/sample-pipeline-build.yaml
$ tkn p start sample-shipwright-build --showlog
```


