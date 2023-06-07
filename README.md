# GitOps to secure your software supply chain

GitOps is the principle of defining all of your resources in Git.
It has become popular throughout the past year. Additionally, projects like ArgoCD and Crossplane are not serving anymore just a niche market but are goining more and more traction through production use cases.

The main benefit of GitOps is gaining higher insights into the deployment process. Knwoing what got deployed when and by whom as well as any of the changed or affected services will make it much easier to identify root causes during an incident.
However, the advantages of using GitOps go much further and extent to cloud native security. 

This tutorial will detail how following GitOps best practices generates higher scan coverage for your resources. 

## GitOps vs. other deployment tools

Lots of tools, such as those focused on platform engineering, try to make the deployment process as "easy as possible" by peviding dashboards and interfaces that allow you to deploy containers and other resources through a few clicks. While this can be great to test out running workloads, it does not scale well nor is it providing production-like environments that would make it possible to stress-test our resources and similar.

## Setting up your GitOps workflow

We are going to set up an example workflow through ArgoCD to demonstrate how an application would be deployed and managed. 

### Prerequisites

* kubectl installaed
* the Terraform CLI installed

### Intall the Kubernetes cluster

In this example, I have set up the Terraform configuration to create a kind Kubernetes cluster. If you are on a Mac, this won't work and you will have to create a cluster manually. Make sure that you have kind installed and then run:
```
kind create cluster --name demo
```

The configuration can be found in the [./terraform-infra](./terraform-kind-cluster/) directory
* provider.tf -- contains the Kind Provider, you could use any other cloud provider or provider that helps you create a Kubernetes cluster
* cluster.tf -- this file containes the cluster Resources that will be created through the provider

Next, we can go into the directory and initialise the Terraform state: *I think this is how you say it
```
cd terraform-infra
terraform init
```

This will provide us with the terraform specific resources.

Next, you can either do first a 'terraform plan' to view the resources that will be created -- in our case this is just going to be the Digital Ocean Kubernetes cluster -- or you can go ahead and run the apply command:
```
terraform apply
```

If you are not in the terraform-infra directory, you will have to specify the directory in which you want to run the command.

Once you run `terraform apply` it will show you the resources that will be created, changed, or deleted -- review the list and if you are happy with it, then type `yes` and press enter.

The creation of the Kubernetes cluster might take several minutes depending on which cloud provider you are using.

### Installing ArgoCD

Next, we are going ahead and installing ArgoCD inside of our cluster through Terraform.

This is going to be the same process as with the cluster installation.

The terraform-app directory contains the following files:
* provider.tf -- this file requires multiple providers; the Kubernetes provider to install our argo-cd namespace, the Helm provider to install the ArgoCD Helm chart and the DigitalOcean provider to connect to our cluster in the first place
* argo-helm.tf -- this file specifies the Helm installation for ArgoCD
* terraform.tfvars -- this file contains the digital ocean token as well as the output from the `terraform-infra apply stage`. The information will be used to connect to the Digital Ocean account and access the previously created cluster.
* variables.tf -- here we define the variables that we are using in this module

Next, you can either do first a 'terraform plan' to view the resources that will be created -- in our case this is just going to be the argocd namespace and the argocd Helm Chart within -- or you can go ahead and run the apply command:
```
terraform apply
```

If you are not in the terraform-app directory, you will have to specify the directory in which you want to run the command.

Once you run `terraform apply` it will show you the resources that will be created, changed, or deleted -- review the list and if you are happy with it, then type `yes` and press enter.

The creation of the Helm Chart might take a couple of minutes (2 or 3).

## Installing our application resources through ArgoCD

You can now view the ArgoCD Helm Chart in the argocd namespace

We have specified two Application installations that will be managed by ArgoCD in the argocd directory:

* app.yaml -- this file has the details to our Application installation
* trivy-operator.yaml -- this file defines how the Trivy Operator will be installed
* k8sgpt.yaml -- this file defines how the K8sGPT Operator will be installed
* promtheus -- this file defines how the Kube Prometheus Stack Operator will be installed
 
We have already defined in the manifests that those resources will be given to ArgoCD in the argocd namespace. Lastly, we can apply the resources through the following command:
```
kubectl apply -f ./argocd
```

This will install all the resources at once. You then have to makes sure that they are synced in ArgoCD.
This can be done in the UI.

First, access the ArgoCD secret:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

and then doing a port-forward on the ArgoCD service:
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

the username is `admin` and the password is the secret from the command before.

More information can be found in the [ArgoCD docs]([ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/).

## Security Benefits

Now that we have seen how an application can be deployed and managed through GitOps best practices, let's look at some of the advanteges this brings to our security scanning.

We could be using something like Crossplane to provision our infrastructure resources such as our Kubernetes cluster. However in that case, we would not be able to scan our infrastructure resources for misconfiguration issues.

Several security scanners, including Trivy are able to scan Terraform resources for misconfiguration issues.

More information can be found on the [Trivy documentation](https://aquasecurity.github.io/trivy/).

## Other applications used in this demo

K8sGPT: https://k8sgpt.ai/

K8sGPT gives Kubernetes Superpowers to everyone

k8sgpt is a tool for scanning your kubernetes clusters, diagnosing and triaging issues in simple english. It has SRE experience codified into its analyzers and helps to pull out the most relevant information to enrich it with AI.