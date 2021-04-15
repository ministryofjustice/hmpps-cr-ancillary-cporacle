# HMPPS Community Rehabilitation Ancillary Application - CPOracle

## Terraform IAC Repository

### Purpose
This repo is to create the CPOracle Application resources in the target AWS Accounts

### Documentation: 
See https://dsdmoj.atlassian.net/wiki/spaces/DAM/pages/3148874745/CP+Oracle for the proposed architecture.

## Architecture Diagrams in Confluence
These diagrams are in Draw.io format

To edit the diagrams:
- Download the draw.io editor tool from https://github.com/jgraph/drawio-desktop/releases
- Create a branch on this repo
- Edit the files in the draw.io editor
- Export the diagrams to PNG format and import them into the confluence pages
- Create a PR and merge the document changes

### Draw.io files



| File                                | Parent Confluence Page                                                                        | Diagram Name          | Notes |
|-------------------------------------|-----------------------------------------------------------------------------------------------|-----------------------|-------|
| diagrams/CPOracleProposedAWS.drawio | https://dsdmoj.atlassian.net/wiki/spaces/DAM/pages/3159621747/CP+Oracle+Proposed+Architecture | Proposed Architecture |       |
| .                                   | .                                                                                             | .                     |       |
| .                                   | .                                                                                             | .                     |       |

## Manual Deployment

Note: This repo uses Terraform 0.13

### common
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=common tg apply -compact-warnings
```

### security-groups
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=security-groups tg apply -compact-warnings
```

### iam
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=iam tg apply -compact-warnings
```

### rds
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=rds tg apply -compact-warnings
```

### ec2
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=ec2 tg apply -compact-warnings
```

### monitoring
```
ENVIRONMENT=cr-unpaid-work-dev CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=monitoring tg apply -compact-warnings
```