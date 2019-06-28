variable "workspace_names" {
  description = "A list of workspace names"
  // Example: ["wkspc1", "wkspc2"]
  type    = "list"
}

variable "prefix" {
    description = "Workspace name prefix"
}

variable "organization_name" {
    description = "Your TFE organization name"
}

variable "vcs_identifier" {
    description = "Name of one previously configured VCS connection in TFE"
    // Example: GitHub
}

variable "oauth_token" {
    description = "Oath Token ID of the above previously configured VCS connection in TFE"
}



