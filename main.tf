// Set TFE_TOKEN as environment variable
// Set TFE_HOSTNAME as environment variable

provider "tfe" {
}

resource "tfe_workspace" "child_workspace" {
  count        = "${length("${var.workspace_names}")}"
  name         = "${var.prefix}-${count.index}"
  organization = "${var.organization_name}"
  queue_all_runs = false
  auto_apply   = false
  terraform_version = "0.11.14"

  vcs_repo = {
    branch         = "master"
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

// Variables documented here
//https://www.terraform.io/docs/providers/tfe/r/variable.html

resource "tfe_variable" "test" {
  count        = "${length("${var.workspace_names}")}"
  key          = "my_key_name"
  value        = "my_value_name"
  category     = "terraform"
  workspace_id = "${element(tfe_workspace.child_workspace.*.id, count.index)}"
}


resource "tfe_variable" "test_sensitive" {
  key          = "my_sensitive_key_name"
  value        = "my_value_name"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${element(tfe_workspace.child_workspace.*.id, count.index)}"
}

// If you have Vault, you could retrieve a secret using the Vault provider
// https://www.terraform.io/docs/providers/vault/index.html

/**
// Connects to Vault
provider "vault" {
  # Set VAULT_ADDR as environment variable
  # Set VAULT_TOKEN as environment variable
}

// Reads static secret
data "vault_generic_secret" "static_secret" {
  path = "secret/password"
 }

// Stores static secret in workspaces as sensitive var
resource "tfe_variable" "test_sensitive" {
  key          = "my_static_secret"
  value        = "my_value_name"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${element(tfe_workspace.child_workspace.*.id, count.index)}"
}

// Generates AWS credentials
data "vault_aws_access_credentials" "aws_creds" {
  backend = "aws"
  role    = "contributor"
}

// Stores AWS keys in workspaces as sensitive var
resource "tfe_variable" "aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${vault_aws_access_credentials.aws_creds.access_key}"
  category     = "env"
  sensitive    = false
  workspace_id = "${element(tfe_workspace.child_workspace.*.id, count.index)}"
}

resource "tfe_variable" "aws_secret" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${vault_aws_access_credentials.aws_creds.secret_key}"
  category     = "env"
  sensitive    = true
  workspace_id = "${element(tfe_workspace.child_workspace.*.id, count.index)}"
}

*/


