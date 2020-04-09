##
## Output variables
##

output "jenkins_url" {
  value = "${aws_instance.jenkins.public_dns}:8080"
}
