# Vault Terraform Template

This code provides a basic Terraform template for deploying a single instance on Vauls secure Critical Infrastructure and Government Cloud. All information provided is intended for reference and educational purposes. Vault uses the OpenStack platform which is compatible with the OpenStack provider on Terraform.

This guid covers linux and MacOS terminal commands. Equivalent steps for sourcing the openrc.sh file can be found in Vaults customer KB

## Prerequisites

### Terraform
Terraform can be installed following the guide found [here.](https://www.terraform.io/downloads.html)

For MacOS a quick installation using brew can be used.

```bash
brew update
brew install terraform
```

### Vault Cloud Access
- Access to a Vault Cloud Openstack Project.
- Access to Vaults API endpoint via VPN

## Deploying Template

### Update Variables file
#### Step 1
Gather the appropriate details for the variables required. In this example there are three variables required. This first two values can be found by downloading and viewing the cloud open-rc file found on the web dashboard (Project > Compute > API Access > Click "DOWNLOAD OPENSTACK RC FILE V2.0"). Keypair name can be found on the web dashboard also (Project > Compute > Keypairs)

- Tenant ID 
- Auth URL
- Keypair Name
 
#### Step 2
Replace the values with the corresponding text in all capps found in the variables.tf file then save the file

for example
```
variable tenant_id {
  description = "Openstack Tenant ID Found in your openrc.sh file or Project > Compute API Access in the web GUI"
  default = "ENTER TENANT ID HERE"
  }
```
replace with the Tenant ID

```
variable tenant_id {
  description = "Openstack Tenant ID Found in your openrc.sh file or Project > Compute API Access in the web GUI"
  default = "LJcBjcUpMmhRmceZHQEHr4JDgd4vnKq3"
  }
```

### Connect to Vaults VPN
Connecting to the VPN allows you to interact with the API endpoints which are required for Terraform to work. If you don't have accesss to the VPN please contact your Vault representative or the Vault Support team.

### Source your project openrc.sh file
To authenitcate to the cloud API endpoint you will need to setup an environment variable on your terminal session. This is done through a script called the openrc.sh file.

Once the file has been downloaded (See "Update Variables file") The following command will create the environment variables for authentication.

```
source <path to openrc.sh file>
```

This will ask you to authenticate with your password.

for example

```
bash-3.2$ source ~/Downloads/demo-openrc.sh
Please enter your OpenStack Password for project demo as user demo-user:
```

### Initialize Terraform 
The following will initialize the working directory containing your Terraform configuration file.

1. Change to the location of the terraform configuration file
```
cd ~/vault_terraform_template
```
2. Run the terraform initilization
```
terraform init
```

### Check your planned changes
Running ```terraform plan``` is good practice before deploying the infrastructure. Here plan command will show you the set of changes to be made before executing a new configuration.

```
terraform plan
```

### Deploy your changes
Applying your changes will start the deployment process. Once completed your defined terraform configuration found in the terraform_basic.tf fill will be live

```
terraform apply
```
