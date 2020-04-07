##
## Output variables
##

output "aws_docker_hub" {
  value = aws_ecr_repository.sparkling_water_registry.repository_url
}
