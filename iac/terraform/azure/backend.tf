terraform {
  cloud {
    organization = "vpapakir"
    workspaces {
      name = "datafactory-azure-dev"
    }
  }
}