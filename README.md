# GitOps to secure your software supply chain

GitOps is the principle of defining all of your resources in Git.
It has become popular throughout the past year. Additionally, projects like ArgoCD and Crossplane are not serving anymore just a niche market but are goining more and more traction through production use cases.

The main benefit of GitOps is gaining higher insights into the deployment process. Knwoing what got deployed when and by whom as well as any of the changed or affected services will make it much easier to identify root causes during an incident.
However, the advantages of using GitOps go much further and extent to cloud native security. 

This tutorial will detail how following GitOps best practices generates higher scan coverage for your resources. 

## GitOps vs. other deployment tools

Lots of tools, such as those focused on platform engineering, try to make the deployment process as "easy as possible" by peviding dashboards and interfaces that allow you to deploy containers and other resources through a few clicks. While this can be great to test out running workloads, it does not scale well nor is it providing production-like environments that would make it possible to stress-test our resources and similar.

## Setting up your GitOps workflow

We are going to set up an example workflow through ArgoCD to demonstrate how an application would be deployed and managed. In this section, we will showcase 
* Installing our Digital Ocean Kubernetes cluster through Terraform
* Installing ArgoCD through Terraform
* Setting up your application, containerising it, and creating the deployment resources
* Setting up your GH Action pipeline
* Installing your application through ArgoCD alonside other manifests to manage it

### Prerequisites

* kubectl installaed
* the Terraform CLI installed

### Intall the Kubernetes cluster

In this example, I have set up the Terraform configuration to install a Kubernetes cluster in Digital Ocean through the Digital Ocean provider.

The configuration can be found in the [./terraform-infra](./terraform-infra/) directory
* provider.tf -- contains the Digital Ocean Provider, you could use any other cloud provider or provider that helps you create a Kubernetes cluster
* cluster.tf -- this file containes the cluster Resources that will be created through the provider
* terraform.tfvars -- this file contains the digital ocean token that will be used to connect to the Digital Ocean account
* variables.tf -- here we define the variables that we are using in this module
* outputs.tf -- the output values that we want once the resourcs(s) has been created

Note that if you would like to use this repository exactly as it is, you will have to provide your own Digital Ocean token into the terraform.tfvars file.

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
* argocd-namespace.tf -- this file specified the namespace resource to be created
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

We have already defined in the manifests that those resources will be given to ArgoCD in the argocd namespace. Lastly, we can apply the resources through the following command:
```
kubectl apply -f ./argocd
```

This will install all the resources at once.

## Security Benefits

Now that we have seen how an application can be deployed and managed through GitOps best practices, let's look at some of the advanteges this brings to our security scanning.

We could be using something like Crossplane to provision our infrastructure resources such as our Kubernetes cluster. However in that case, we would not be able to scan our infrastructure resources for misconfiguration issues.

Several security scanners, including Trivy are able to scan Terraform resources for misconfiguration issues.

More information can be found on the [Trivy documentation]().


