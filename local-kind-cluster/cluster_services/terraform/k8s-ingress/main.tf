locals {
  localhost_ports = [
    {
      "name" : "test-service",
      "host_port" : 8001,
      "container_port" : 8001,
      "namespace" : "default",
      "service_name" : "test-service"
      "service_port" : 8080
    },
    {
      "name" : "minio-console",
      "host_port" : 9001,
      "container_port" : 9001,
      "namespace" : "default",
      "service_name" : "minio1-console"
      "service_port" : 9090
    },
    {
      "name" : "minio",
      "host_port" : 9000,
      "container_port" : 9000,
      "namespace" : "default",
      "service_name" : "minio"
      "service_port" : 80
    }
  ]
}
