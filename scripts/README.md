# Kabanero Foundation Scripts

#### Release 0.3 pre-requisties

 - [OCP] (https://www.openshift.com/products/container-platform)  V4.2.0+


## Sample Appsody project with manual Tekton pipeline run

Your cluster may have a Dynamic Storage Provisioner.  If not, create a `Persistent Volume` for the pipeline to use. A sample NFS based  `pv.yaml` is provided.  Update the `pv.yaml` file with your NFS server file.  It usually is your infrastructure node address.
```
oc apply -f pv.yaml
```

Create the pipeline and execute the example manual pipeline run
```
APP_REPO=https://github.com/dacleyra/appsody-hello-world/ ./example-tekton-pipeline-run.sh
```

By default, the application container image will be built and pushed to the Internal Registry in the kabanero project, and then deployed as a Knative Service.

View manual pipeline logs
```
oc logs $(oc get pods -l tekton.dev/pipelineRun=appsody-manual-pipeline-run --output=jsonpath={.items[0].metadata.name}) --all-containers
```

Access Tekton dashboard at `http://tekton-dashboard.my.openshift.master.default.subdomain`

Access application at `http://appsody-hello-world.kabanero.my.openshift.master.default.subdomain`


## Sample Appsody project with webhook driven Tekton pipeline run

Use appsody to create a sample project

1. Download [appsody](https://github.com/appsody/appsody/releases)
2. Add the kabanero collection repository to appsody `appsody repo add kabanero https://github.com/kabanero-io/collections/releases/download/0.3.0/kabanero-index.yaml`
3. Initialize a java microprofile project `appsody init kabanero/java-microprofile`
4. Push the project to your github repository

Your cluster may have a Dynamic Storage Provisioner.  If not, create a `Persistent Volume` for the pipeline to use. A sample NFS based  `pv.yaml` is provided.  Update the `pv.yaml` file with your NFS server file.  It usually is your infrastructure node address.

```
oc apply -f pv.yaml
```

Login to the Tekton dashboard using openshift credentials `http://tekton-dashboard-tekton-pipelines.apps.openshift.subdomain`

Use the service account called `kabanero-pipeline` to run your pipeline.  If your github repository is private, create a secret with your github credentials and associate the secret with the service account.

Create a webhook using the dashboard, providing the necessary information. Provide the access token for creating a webhook.

![](webhook.png)

![](cats.png)

Once the webhook is created, the dashboard generates a webhook in github. Verify the webhook is created by accessing.

https://github.com/YOURORG/appsody-hello-world/settings/hooks/

If the webhook payload was not successfully delivered, this may be due to a timeout of the webhook sink not starting in a timely manner. If so, select the failed webhook delivery in github, and redeliver it.

Trigger the pipeline.

Make a simple change to the application repository, such as updating the README.

In the Tekton dashboard, you should observe a new PipelineRun execute as a result of the commit and webhook.

