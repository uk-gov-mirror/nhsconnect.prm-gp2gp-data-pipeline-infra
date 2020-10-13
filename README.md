# prm-gp2gp-data-pipeline-infra

## Setup

These instructions assume you are using:
- [aws-vault](https://github.com/99designs/aws-vault) to validate your aws credentials.
- [dojo](https://github.com/kudulab/dojo) to provide an execution environment

## Applying terraform

### Enter the container:

`aws-vault exec <profile-name> -- dojo`

### Invoke terraform

```
  ./tasks validate
  ./tasks plan
```
