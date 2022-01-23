# VisualTez Infrastructure Automation

**`VisualTez`** uses the Google Cloud Platform for its infrastructure.

## Dependencies

|     |   |
|:---:|:-:|
| **terraform** | https://www.terraform.io/downloads |
| **git** | https://git-scm.com/downloads |
| **gsutil** | https://cloud.google.com/storage/docs/gsutil_install |

## Deploy infrastructure

```sh
terraform init
# Or upgrade components with "terraform init -upgrade"
terraform apply
```

## Publish TezWell frontend

```sh
./scripts/publish_frontent.sh
```
