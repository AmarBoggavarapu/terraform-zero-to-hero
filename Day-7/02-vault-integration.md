# Vault Integration

Here are the detailed steps for each of these steps:

## Create an AWS EC2 instance with Ubuntu

To create an AWS EC2 instance with Ubuntu, you can use the AWS Management Console or the AWS CLI. Here are the steps involved in creating an EC2 instance using the AWS Management Console:

- Go to the AWS Management Console and navigate to the EC2 service.
- Click on the Launch Instance button.
- Select the Ubuntu Server xx.xx LTS AMI.
- Select the instance type that you want to use.
- Configure the instance settings.
- Click on the Launch button.

## Install Vault on the EC2 instance

To install Vault on the EC2 instance, you can use the following steps:

**Install gpg**

```
sudo apt update && sudo apt install gpg
```
Vault by default is not available as a package in our ubuntu machine. So, we are adding Hashi Corp Package manager to ubuntu. Whenever, there is no package available we can get those from the provider (https://apt.releases.hashicorp.com) who provides these.

**Download the signing key to a new keyring**

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

**Verify the key's fingerprint**

```
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

**Add the HashiCorp repo**

```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```
sudo apt update
```

**Finally, Install Vault**

```
sudo apt install vault
```

**Check the version of Vault**

```
vault --version
```

## Start Vault.

To start Vault, you can use the following command:

```
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

Vault comes in 2-modes, Development mode (Can be used for POCs, learning, demo, practice) and Production mode (For Organizational tasks).

```
Keep above running vault as-is.

Open a new terminal and run all the below commands in the new terminal.

$ export VAULT_ADDR='http://0.0.0.0:8200'
```

## To access the vault GUI, we need to add "Inbound role" for the security group associated with our EC2 instance.
EC2 --> Instances --> i-xxxxxxxx --> Security --> Security groups (sg-xxxxxx) --> Inbound rules --> Edit Inbound rules.

Type:        Custom TCP
Protocol:    TCP
Port range:  8200
Source:      0.0.0.0/0

Once above Inbound role is added to security group, we can access the EC2 instance from GUI (Browser)
http://54.89.99.162:8200/   ## Public IP of EC2 instance with port 8200

## Sign-in to vault
There are multiple ways to sign-in to vault, for this demo - we will use the mode of Root Token.
Method: Token
Token: Root token (we can see this from 1st terminal which we kept aside after starting vault in dev mode - sample as shown below).

````
The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: HOoLh/XXXXXXXX
Root Token: hvs.XXXXXXXXXXXX
````
Once logged-in, you will get root access to vault.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Secret Engines are like different types of engines we can create in Hashi Corp Vault.

For storing Kubernetes secret, we can use Kubernetes secret engine.

For storing regular key-value pair, we can use "kv" secret engine.

By default, no secrets engine is enabled in Hashi Corp Vault.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

**## Enabling new secrets engine**
````
Secrets Engines --> Enable new engine --> kv (for this demo, we will use key-value pair, kv secret engine) --> path (give a unique and meaningful name, This is like a mount to store the credentials) --> Example path: kv --> Enable Engine.

````
Hashicorp vault is popular, as it does encryption once we enter in vault secret engine. At the path or at instance level - it will store only the encrypted information. Decrypted information is available only in the vault.

**## Creating secret**
kv (Name of path created in previous step) --> create secret --> path for this secret (give a unique and meaningful name) --> Example path for this secret: kv-path --> secret data --> Key and Value --> Add --> Save

Above secret is created with root user. So only root will have access.

Now to access this secret via ansible or terraform --> We need to create a role inside your vault.

Similar to IAM role in AWS --> We have Access
Similar to IAM policy in AWS --> We have Policies

We can't create roles via GUI, so we will run below set of commands in the 2nd terminal which we have started earlier.

## Configure Terraform to read the secret from Vault.

Detailed steps to enable and configure AppRole authentication in HashiCorp Vault:

1. **Enable AppRole Authentication**:

To enable the AppRole authentication method in Vault, you need to use the Vault CLI or the Vault HTTP API.

**Using Vault CLI**:

Run the following command to enable the AppRole authentication method:

```bash
vault auth enable approle
```

This command tells Vault to enable the AppRole authentication method.

2. **Create an AppRole**:

We need to create policy first,

```
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF
```
Above step will create a new policy named "terraform".
**Success! Uploaded policy: terraform**

Now you'll need to create an AppRole with appropriate policies and configure its authentication settings. Here are the steps to create an AppRole:

**a. Create the AppRole**:

```bash
vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform
```

3. **Generate Role ID and Secret ID**:

After creating the AppRole, you need to generate a Role ID and Secret ID pair. The Role ID is a static identifier, while the Secret ID is a dynamic credential.

**a. Generate Role ID**:

You can retrieve the Role ID using the Vault CLI:

```bash
vault read auth/approle/role/terraform/role-id
```

Save the Role ID for use in your Terraform configuration.

**b. Generate Secret ID**:

To generate a Secret ID, you can use the following command:

```bash
vault write -f auth/approle/role/terraform/secret-id
   ```

This command generates a Secret ID and provides it in the response. Save the Secret ID securely, as it will be used for Terraform authentication.
