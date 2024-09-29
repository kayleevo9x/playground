terraform {
  cloud {

    organization = "kayleev-playground"

    workspaces {
      name = "default"
    }
  }
}
