# prm-gp2gp-data-pipeline-infra

## Applying terraform

### Enter the container:

`dojo -identity-dir-outer=<your-dojo-identity-directory>`

### Assume admin role:

`aws eval $(aws-cli-assumerole -rmfa <role-arn> <mfa-code>)`

### Validate that you assumed the correct role:

`aws sts get-caller-identity`

### Invoke terraform

```
  export STACK=data-pipeline
  export ENVIRONMENT=dev
  terraform init -backend-config key=${ENVIRONMENT}/${STACK}/terraform.tfstate
  terraform apply -var environment=${ENVIRONMENT}
```
