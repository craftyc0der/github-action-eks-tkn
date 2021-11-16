# GitHub Action that run a Tekton Task on remote EKS Cluster

This is accomplished by this plugin to your workflow.

If you require the addition of a tolerations or affinity, these are included in the optional `pod_template` input. The `args` are arguments to the `tkn task start` command. It will fail if you try to overload the command with symbols that would allow new executions with the AWS permissions. So, avoid  symbols like `${[()]}|&;` in your `namespace`, `task`, or `args`.


## Inputs

* task
  * The Tekton task name
* cluster_task
  * The Tekton clustertask name (mutually exclusive with `task`)
* namespace
  * The K8S namespace the Task resides in
* args
  * Arguments to append the to tkn task start command
* pod_template
  * YAML contents of a pod_template to apply to the TaskRun we create
* kubeconfig
  * YAML contents of the .kube/config file you want to use
* aws_access_key_id
  * AWS access key
* aws_secret_access_key
  * AWS secret key
* aws_region
  * AWS region

## Example

## Running a Tekton Task in GitHub Actions

```bash
   - name: Run tekton task
      id: tkn
      uses: craftyc0der/github-action-eks-tkn@v1
      with:
        task: 'unity-build'
        namespace: 'astra-build'
        serviceaccount: 'astra-build'
        args: '--param gitOrg=gosynthschool --param gitRepo=rubicon --param gitSha=3c4356f --param s3UploadPath=s3://rubicon-prod/jom --param unityLicenseSecret=unity-license'
        kubeconfig: '${{ secrets.KUBECONFIG_EKS_DEMO_CLUSTER_ASTRA }}'
        aws_access_key_id: '${{ secrets.AWS_ACCESS_KEY_ID_ASTRA_GITHUB_USER }}'
        aws_secret_access_key: '${{ secrets.AWS_SECRET_ACCESS_KEY_ASTRA_GITHUB_USER }}'
        aws_region: 'us-east-2'
        pod_template: |
          tolerations:
          - key: "tekton"
            operator: "Equal"
            value: "true"
            effect: "NoSchedule"
          - key: "cpu"
            operator: "Equal"
            value: "8"
            effect: "NoSchedule"
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: role
                    operator: In
                    values:
                    - tekton
```