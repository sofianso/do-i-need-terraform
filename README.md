## How To Run
1. Run `terraform init` will download the necessary files to talk to AWS. 
2. To check what will be modified/created, run `terraform plan`.
3. Run `terraform apply` to apply the changes.

## To Delete Terraform Resources
1. Run `terraform destroy` to destroy every resources that was created in the the terraform file.

## Hiding Secret Keys Variables
1. Open AWS config folder and modify both `config` and `credentials` files. 

If you are on Mac, first locate the hidden `.aws` folder, run `ls -a` to show all the hidden files. You'll see `.aws` folder. Navigate and click on both `config` and `credentials`. 

Edit the `config` file:
```bash
[sofian-outlook]
region = ap-southeast-2
output = json
```

Edit the `credentials` file:
```bash
[sofian-outlook]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```
