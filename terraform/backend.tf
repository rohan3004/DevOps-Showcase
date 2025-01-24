terraform {
  backend "remote" {
    organization = "DevOps_Rohan_Testing"
    workspaces {
      name = "my-first-workspace"
    }
  }
}
