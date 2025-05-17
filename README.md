# Enabling a GUI on an AWS EC2 Ubuntu Instance

### Create terraform.tfvars
```shell
 ingress_cidr_block=["xxx.xxx.xxx.xxx/32"]
 instance_password="Your_super_secret_passowrd"
```

```shell
terraform init

terraform plan

# Replace password
terraform apply -var="instance_password=my-secure-password" --auto-approve
```

```shell
# Get the latest AMI's

aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/*" \
  --query "Images[*].[ImageId,Name]" \
  --output table
```
