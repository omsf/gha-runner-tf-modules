# gha-runner-tf-modules
This repository contains Terraform/OpenTofu modules to easily setup needed steps on AWS and GitHub for [`gha-runner`](https://github.com/omsf/gha-runner).

Both modules are located under the modules folder. 
You have one for configuring `gha-runner` on AWS and one for setting up GitHub's OIDC provider on AWS.
We split these out to ensure that users can use this for other use-cases other than the one we are using here.
