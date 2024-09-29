locals {
  prefix   = "hello-world"
  location = "Canada East"
  tags = {
    Terraform   = "True"
    Environment = "Playground"
  }
  image_name          = "helloworld-asp-api:latest"
  docker_registry_url = "ghcr.io/kayleevo9x/playground"
}
