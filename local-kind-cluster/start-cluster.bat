./scripts/download_execs.sh `pwd`
./kind-with-registry.sh ./executables/windows/kind-amd64.exe
./scripts/terraform_cluster_services.sh

