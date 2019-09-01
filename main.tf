resource "docker_image" "flink" {
  name = "flink:latest"
}

resource "docker_network" "test_network" {
  name = "test_network"
}

resource "docker_container" "jobmanager" {
  image = "${docker_image.flink.latest}"
  name = "jobmanager"
  ports {
    internal = 8081
    external = 8081
  }
  command = [
    "jobmanager"
  ]
  env = [
    "JOB_MANAGER_RPC_ADDRESS=jobmanager"
  ]
  networks_advanced {
    name = "${docker_network.test_network.name}"
  }
}

resource "docker_container" "taskmanager" {
  image = "${docker_image.flink.latest}"
  name = "taskmanager"
  depends_on = [
    "docker_container.jobmanager"
  ]
  command = [
    "taskmanager"
  ]
  env = [
    "JOB_MANAGER_RPC_ADDRESS=${docker_container.jobmanager.name}"
  ]
  networks_advanced {
    name = "${docker_network.test_network.name}"
  }
}
