# GitOps to secure your software supply chain

GitOps is the principle of defining all of your resources in Git.
It has become popular throughout the past year. Additionally, projects like ArgoCD and Crossplane are not serving anymore just a niche market but are goining more and more traction through production use cases.

The main benefit of GitOps is gaining higher insights into the deployment process. Knwoing what got deployed when and by whom as well as any of the changed or affected services will make it much easier to identify root causes during an incident.
However, the advantages of using GitOps go much further and extent to cloud native security. 

This tutorial will detail how following GitOps best practices generates higher scan coverage for your resources. 

## GitOps vs. other deployment tools

Lots of tools, such as those focused on platform engineering, try to make the deployment process as "easy as possible" by peviding dashboards and interfaces that allow you to deploy containers and other resources through a few clicks. While this can be great to test out running workloads, it does not scale well nor is it providing production 

## Setting up your GitOps workflow

We are going to set up an example workflow through ArgoCD to demonstrate how an application would be deployed and managed. In this section, we will showcase 
* Installing ArgoCD
* Setting up your application, containerising it, and creating the deployment resources
* Setting up your GH Action pipeline
* Installing your application through ArgoCD alonside other manifests to manage it

### Prerequisites

* A running Kubernetes cluster, ideally from a managed provider to follow the entire tutorial

### Installing ArgoCD

First of all, we are going ahead and installing ArgoCD inside of our cluster through Terraform.





## Security Benefits

Now that we have seen how an application can be deployed and managed through GitOps best practices, let's look at some of the advanteges this brings to our security scanning.

