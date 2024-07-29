#Install gpg

sudo apt update && sudo apt install gpg

#Download the signing key to a new keyring

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

#Verify the key's fingerprint
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

#Add the HashiCorp repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
#Finally, Install Vault

sudo apt install vault

#Start Vault.

vault server -dev -dev-listen-address="0.0.0.0:8200"

#Enable AppRole Authentication:


#Set the Correct Vault Address

export VAULT_ADDR='http://127.0.0.1:8200'


#Steps to Create and Apply a Policy

#Save the following policy definition to a file named example-policy.hcl:

path "kv/data/*" {
  capabilities = ["read"]
}

vault policy write example-policy example-policy.hcl
vault write auth/approle/role/example-role policies=example-policy

#Retrieve the Role ID:
vault read auth/approle/role/example-role/role-id

#Retrieve the Secret ID:
 vault write -f auth/approle/role/example-role/secret-id



