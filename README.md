# Enabling a GUI on an AWS EC2 Ubuntu Instance

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