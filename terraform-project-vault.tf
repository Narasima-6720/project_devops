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

#role

vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform


#Retrieve the Role ID:
vault read auth/approle/role/terraform/role-id

#Retrieve the Secret ID:
 vault write -f auth/approle/role/terraform/secret-id



