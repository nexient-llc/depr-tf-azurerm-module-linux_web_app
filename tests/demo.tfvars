resource_group = {
  name = "deb-test-devops"
  location = "eastus"
}

storage_account = {
  name = "debtestbucket123"
  rg_name = "vvc-rg-wus-prod"
}

service_plan = {
  name = "deb-test-service-plan"
  rg_name = "deb-test-devops"
}

container_registry = {
  name = "nexientacr000"
  rg_name = "deb-test-devops"
}

web_app_name = "demo-eus-dev-000-app-000"

application_stack = "docker"

docker_image_name = "python-docker"
docker_image_tag = "1.0.0"

application_settings = {
  provisioner = "Terraform" 
  WEBSITES_PORT = 5000
}

http_logs_file_system = {
  retention_in_days = 14
  retention_in_mb = 100
}

deployment_slots = ["stage"]

enable_system_managed_identity = true